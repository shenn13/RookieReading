//
//  BookReaderController.m
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookReaderController.h"

#import "Reachability.h"
#import "BookComicDetail.h"
#import "BookDetail.h"

#import "BookReaderCell.h"
#import "ReaderMenuCell.h"
#import "ReaderToolCell.h"

#import "PublicWebController.h"
#import "ComicListViewController.h" // 章节列表界面
#import "PersonalCenterController.h"
#import "PostCommentController.h"

#import "BookImageComent.h"  // 图片数据对象

#import "SDTimeLineBaseCell.h" // 评论CELL
#import "SDTimeLineImageCell.h"

@interface BookReaderController ()<ComicListVCDelegate,ReaderMenuCellDelegate,SDTimeLineBaseCellDelegate,PostCommentControllerDelegate>

@property (nonatomic,strong)UIButton *goBottom;

/**
 *  获取章节列表
 */
@property (nonatomic,strong)BookDetail *bookDetail;

/**
 *  当前正在阅读的章节
 */
@property (nonatomic,strong)BookComicDetail *comicDetail;

/**
 *  处理之后的评论数据
 */
@property (nonatomic,strong)NSMutableArray *handleDataSource;

@property (nonatomic,assign)NSInteger since;

@end

@implementation BookReaderController

-(instancetype)initWithComicId:(NSString *)comicId
{
    if (self = [super init])
    {
        self.comicId = comicId;
        
        self.since = 0;
    }
    return self;
}


/**
 *  章节图片数据请求
 */
-(void)comicImageDataRequest
{
    [self startActivityWithText:REQUESTTIPING];
    
    kSelfWeak;
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    NSDictionary *param;
    if (self.comicId.length > 0) {
        param = @{@"comicId":self.comicId};;
    }
    if (param.count < 1) {
        [self stopActivityWithText:@"章节ID无效!" state:ActivityHUDStateFailed];
        return;
    };
    
    [request baseRequestWithMethod:[request getMethodWithType:UrlTypeOfFour param:param] requestType:RequestTypeOfKuaiKan params:nil completion:^(NSDictionary *responseObject) {
        ActivityHUDState state = ActivityHUDStateFailed;
        if (SUCCESS) {
            state = ActivityHUDStateSuccess;
            BookComicDetail *comicDetail = [BookComicDetail toBookComicDetail:responseObject[@"data"]];
            if (comicDetail) {
                weakSelf.comicDetail = comicDetail;
                weakSelf.navigationItem.title = weakSelf.comicDetail.title;
            
                // 加载评论数据
                [weakSelf.tableView.mj_header beginRefreshing];
            };
            weakSelf.tableView.contentOffset = CGPointZero;
        }
        [weakSelf stopActivityWithText:REQUESTTIPSUC state:state];
    } failure:^(NSError *error) {
        [weakSelf stopActivityWithText:REQUESTTIPFAI state:ActivityHUDStateFailed];
    }];
    
}

/**
 *  评论列表数据查询
 */
-(void)commentsDataRequest:(MJRefreshComponent *)refreshView
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    // comicId
    if (self.comicId.length > 0) {
        [param setObject:self.comicId forKey:@"comicId"];
    }
    [param setObject:@(self.since) forKey:@"finalId"];

    kSelfWeak;
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    [request baseRequestWithMethod:[request getMethodWithType:URLTypeOfFive param:param] requestType:RequestTypeOfKuaiKan params:@{@"limit":PAGESIZE20} completion:^(NSDictionary *responseObject) {
        if (SUCCESS)
        {
            self.since = [responseObject[@"data"][@"since"] integerValue];
            
            NSMutableArray *dataAry = [[BookImageComent toBookImageComent:responseObject[@"data"][@"comments"]] mutableCopy];

            if (dataAry.count > 0)
            {
                 NSMutableArray *newAry = [[BookImageComent toSDTimeLineModelAry:dataAry] mutableCopy];
                if ([refreshView isKindOfClass:[MJRefreshNormalHeader class]])
                {
                    [weakSelf.dataSource removeAllObjects];
                    [weakSelf.handleDataSource removeAllObjects];
                }

                [weakSelf.dataSource addObjectsFromArray:dataAry];
                [weakSelf.handleDataSource addObjectsFromArray:newAry];
                
                [weakSelf.tableView reloadData];
            }
            else
            {
                [weakSelf.tableView reloadData];
                [weakSelf showTextWithState:ActivityHUDStateFailed inView:WINDOW text:@"没有更多数据了!"];
            }
        }
        
        if ([refreshView isRefreshing]) {
            [refreshView endRefreshing];
        }
    } failure:^(NSError *error) {
        if ([refreshView isRefreshing]) {
            [refreshView endRefreshing];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"图书阅读";
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册重用标志
    [self.tableView registerClass:[SDTimeLineImageCell class] forCellReuseIdentifier:kSDTIMELINE_IMAGE];
    
    kSelfWeak;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.since = 0;
        [weakSelf commentsDataRequest:weakSelf.tableView.mj_header];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf commentsDataRequest:weakSelf.tableView.mj_footer];
    }];
    
    /**
     *  导航栏右边按钮
     */
    [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[@"menu_list"] selArr:nil];
    
    // 章节数据获取(网络监测)
    Reachability *reachability   = [Reachability reachabilityWithHostName:SERVERURL_KUAIKAN];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    switch (internetStatus)
    {
        case ReachableViaWWAN:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前正在使用移动网络,继续加载将消耗流量" message:nil delegate:nil cancelButtonTitle:@"待会再看" otherButtonTitles:@"继续加载", nil];
            [alert showWithCompleteBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [weakSelf comicImageDataRequest];
                }
            }];
        }
            break;
        default:
        {
            [self comicImageDataRequest];
        }
            break;
    }
    
}

#pragma mark - 查看章节列表(导航栏右上角点击事件)

-(void)rightBarItemClick:(UIButton *)rightItem
{
    if (self.comicId.length < 1) {
        [self showText:@"当前章节不存在！" inView:self.navigationController.view];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    ComicListViewController *comicList = [[ComicListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    if (self.comicDetail.topic.idd.length > 0) {
        comicList.bookId = self.comicDetail.topic.idd;
    }
    else if (self.comicDetail.topic.idd.length < 1 && self.comicDetail.topic.target_id.length > 0) {
        comicList.bookId = self.comicDetail.topic.target_id;
    }
    
    if (comicList.bookId.length < 1) return;
    
    comicList.comicId = self.comicDetail.idd;
    comicList.delegate = self;
    comicList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:comicList animated:YES];
    
}

#pragma mark - 切换阅读章节（跳跃）

-(void)changeReaderComicWithComicId:(NSString *)comicId
{
    if (comicId.length > 0)
    {
        self.comicId = comicId;
        [self comicImageDataRequest];
    }
}

#pragma mark - ReaderMenuCellDelegate

-(void)commentMenuActionClick
{
    BookImageComent *comment = [[BookImageComent alloc] init];
    comment.comic_id = self.comicId;
    
    PostCommentController *postComment = [PostCommentController postCommentController:nil isReply:NO appType:AppApiTypeOfKuaiKan];
    postComment.kuaiKanComment = comment;
    postComment.delegate = self;
    [self.navigationController pushViewController:postComment animated:YES];
}

-(void)shareMenuActionClick
{
    [self showShareViewWithAppInfo];
}

#pragma mark - 展示分享视图
-(void)shareViewDidClickShare:(ShareType)shareType
{
    SSDKPlatformType type;
    if (shareType == ShareTypeOfWXTimeLine) {
        type = SSDKPlatformSubTypeWechatTimeline;
    }else if (shareType == ShareTypeOfWeiChat){
        type = SSDKPlatformSubTypeWechatSession;
    }else if (shareType == ShareTypeOfQQ){
        type = SSDKPlatformSubTypeQQFriend;
    }else if(shareType == ShareTypeOfWeiBo){
        type = SSDKPlatformTypeSinaWeibo;
    }
    [self shareToPlatform:type url:[NSURL URLWithString:@"http://www.cnblogs.com/silence-wzx/"] image:[UIImage imageNamed:@"kuaiyue_icon 512"] title:@"菜鸟阅读！" text:@"读万卷书,行万里路！"];
}

#pragma mark - KuaiKanPostCommentDelegate代理
-(void)kuaiKanPostComment:(BookImageComent *)kuaiKanComment
{
    if (kuaiKanComment)
    {
        SDTimeLineCellModel *model = [[BookImageComent toSDTimeLineModelAry:@[kuaiKanComment]]firstObject];
        model.showDel = YES;
        [self.dataSource insertObject:kuaiKanComment atIndex:0];
        [self.handleDataSource insertObject:model atIndex:0];
        [self.tableView reloadData];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return MIN(self.comicDetail.image_infos.count, self.comicDetail.images.count);
    }
    else if (section == 1) {
        return 2;
    }
    return self.handleDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSString *imaUrl = self.comicDetail.images[indexPath.row];
        
        BookReaderCell *reader = [BookReaderCell bookCell:tableView];
        [reader.readerImage sd_setImageWithURL:[NSURL URLWithString:imaUrl] placeholderImage:DEFAULT_BG];
        return reader;
    }
    else if (indexPath.section == 1)
    {
        // 上一章、下一章工具栏
        kSelfWeak;
        if (indexPath.row == 1) {
            ReaderMenuCell *readerMenu = [ReaderMenuCell readerMenu:tableView];
            readerMenu.delegate = self;
            return readerMenu;
        }
        
        // 评论 分享
        ReaderToolCell *toolCell = [ReaderToolCell readerTool:tableView];
        toolCell.lastComicId = self.comicDetail.previous_comic_id;
        toolCell.nextComicId = self.comicDetail.next_comic_id;
        toolCell.changeComicBlock = ^(NSString *comicId){
            weakSelf.comicId = comicId;
            [weakSelf comicImageDataRequest];
        };
        return toolCell;
    }
    
    SDTimeLineCellModel *model = self.handleDataSource[indexPath.row];
    SDTimeLineBaseCell *timeLine = [SDTimeLineBaseCell SDTimeLineCell:tableView model:self.handleDataSource[indexPath.row]];
    timeLine.indexPath = indexPath;
    timeLine.delegate = self;
    // 高度缓存
    [timeLine useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    timeLine.model = model;
    return timeLine;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self.comicDetail.image_infos[indexPath.row] scaleHeight];
    }else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            return 46.f;
        }
        return [ReaderToolCell toolHeight];
    }
    
    if (self.handleDataSource.count < 1) {
        return 20;
    }
    SDTimeLineCellModel *model = self.handleDataSource[indexPath.row];
    Class cellClass = [SDTimeLineImageCell class];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:cellClass contentViewWidth:[self cellContentViewWith]];
}

#pragma mark - SDTimeLineBaseCellDelegate代理

-(void)didClickTopHeaderViewInCell:(SDTimeLineBaseCell *)cell circleHeaderViewAction:(CircleHeaderViewActionType)type
{
    LOGINNEED_ACTION;
    
    BookImageComent *mdoel = self.dataSource[cell.indexPath.row];
    
    NSString *atUserId = mdoel.user.idd;
    
    if (atUserId.length < 1) return;
    
    if (type == CircleHeaderViewActionOfIcon || type == CircleHeaderViewActionOfName)
    {
        PersonalCenterController *personVC = [[PersonalCenterController alloc] init];
        personVC.atUserId = atUserId;
        personVC.appType = AppApiTypeOfKuaiKan;
        [self.navigationController pushViewController:personVC animated:YES];
    }
    else if (type == CircleHeaderViewActionOfTextContent)
    {
        //[self showText:@"文本内容" inView:self.navigationController.view];
    }
}

-(void)didClickDescriptionMenuInCell:(SDTimeLineBaseCell *)cell opeartionMenu:(OperationMenu)menu
{
    LOGINNEED_ACTION;
    
    BookImageComent *model = self.dataSource[cell.indexPath.row];
    SDTimeLineCellModel *timeLineModel = self.handleDataSource[cell.indexPath.row];
    
    if (menu == OperationMenuOfDelete)
    {
        [self.handleDataSource removeObjectAtIndex:cell.indexPath.row];
        [self.dataSource removeObjectAtIndex:cell.indexPath.row];
        [self.tableView reloadData];
    }
    else if (menu == OperationMenuOfComment) {
        PostCommentController *postComment = [PostCommentController postCommentController:[NSString stringWithFormat:@"回复@%@：",model.user.nickname] isReply:YES appType:AppApiTypeOfKuaiKan];;
        postComment.kuaiKanComment = model;
        postComment.delegate = self;
        [self.navigationController pushViewController:postComment animated:YES];
    }
    else if (menu == OperationMenuOfDianZan) {

        timeLineModel.liked = !timeLineModel.liked;
        timeLineModel.likesCount = [NSString stringWithFormat:@"%ld",[timeLineModel.likesCount integerValue] + 1];
        model.is_liked = !model.is_liked;
        model.likes_count += 1;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)didClickLinkActionInCell:(SDTimeLineBaseCell *)cell type:(MLEmojiLabelLinkType)type link:(NSString *)link linkValue:(NSString *)linkValue
{
    LOGINNEED_ACTION;
    
    BookImageComent *model = self.dataSource[cell.indexPath.row];
    
    if (type == MLEmojiLabelLinkTypeURL)
    {
        PublicWebController *webBorwse = [[PublicWebController alloc] init];
        webBorwse.detailTitle = @"网页浏览";
        webBorwse.detailURL = linkValue;
        [self.navigationController pushViewController:webBorwse animated:YES];
    }
    else if (type == MLEmojiLabelLinkTypeAt)
    {
        PersonalCenterController *personVC = [[PersonalCenterController alloc] init];
        personVC.atUserId = model.replied_user_id;
        personVC.appType = AppApiTypeOfKuaiKan;
        [self.navigationController pushViewController:personVC animated:YES];
    }
}

-(void)didClickMoreBtnInCell:(SDTimeLineBaseCell *)cell
{
    NSIndexPath *indexPath = cell.indexPath;
    SDTimeLineCellModel *model = self.handleDataSource[indexPath.row];
    model.isOpening = !model.isOpening;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITableViewCell *sectionTwoCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (sectionTwoCell){
        if (self.goBottom.hidden == YES) return;
        self.goBottom.hidden = YES;
    }else{
        if (self.goBottom.hidden == NO) return;
        self.goBottom.hidden = NO;
    }
    //NSLog(@"%@",NSStringFromCGRect(sectionTwoCell.frame));
}

-(UIButton *)goBottom
{
    if (!_goBottom) {
        _goBottom = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBottom setTitle:@"去底部" forState:UIControlStateNormal];
        [_goBottom setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _goBottom.titleLabel.font = FONT_BOLD(15);
        _goBottom.backgroundColor = [UIColor whiteColor];
        
        [_goBottom addTarget:self action:@selector(goToSectionTwoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBottom;
}

-(NSMutableArray *)handleDataSource
{
    if (!_handleDataSource) {
        _handleDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _handleDataSource;
}

-(void)goToSectionTwoAction:(UIButton *)goBottom
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.goBottom removeFromSuperview];
    self.goBottom = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.goBottom removeFromSuperview];
    [self.navigationController.view addSubview:self.goBottom];
    [self.goBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.bottom.offset(-10);
        make.width.height.equalTo(@(50));
    }];
    self.goBottom.layer.masksToBounds = YES;
    self.goBottom.layer.cornerRadius = 25.f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
