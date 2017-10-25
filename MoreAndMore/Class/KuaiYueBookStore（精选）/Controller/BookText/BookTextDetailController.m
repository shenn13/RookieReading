//
//  BookTextDetailController.m
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextDetailController.h"
#import "PersonalCenterController.h"
#import "PublicWebController.h"
#import "BookTextThemeListController.h"
#import "BookTextListViewController.h"

#import "CBReaderPageController.h"

#import "BookTextHeaderView.h"
#import "HXTagsView.h"

#import "TextBookDetail.h"
#import "TextReviewModel.h"
#import "RecommendBookModel.h"

#import "SDTimeLineImageCell.h"
#import "BookTextMoreCell.h"
#import "RecomendTextBookCell.h"

@interface BookTextDetailController ()<BookTextHeaderViewDelegate,SDTimeLineBaseCellDelegate>

@property (nonatomic,strong)BookTextHeaderView *headerView;

@property (nonatomic,strong)TextBookDetail *textDetail;

// 热门书评
@property (nonatomic,strong)NSMutableArray *reviewAry;
@property (nonatomic,strong)NSMutableArray *handleReviewAry;

// 推荐书单
@property (nonatomic,strong)NSMutableArray *recommendAry;

@end

@implementation BookTextDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"书籍详情";
    
    // 注册重用标志
    [self.tableView registerClass:[SDTimeLineImageCell class] forCellReuseIdentifier:kSDTIMELINE_IMAGE];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = LINE_COLOR;
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    /**
     *  界面设置
     */
    self.headerView.textBook = self.textBook;
    self.tableView.tableHeaderView = self.headerView;
    
    /**
     *  导航栏配置
     */
    [self configNavBarWithCollected];

    /**
     *  书籍详情数据请求
     */
    [self textBookMessageRequest];
}

#pragma mark - 导航栏配置

-(void)configNavBarWithCollected
{
    NSString *itemStar = self.textBook.isCollect ? @"ratingStar_full" : @"ratingStar_empty";
    
    [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[itemStar] selArr:nil];
}

#pragma mark - 导航栏右边按钮点击事件

-(void)rightBarItemClick:(UIButton *)rightItem
{
    LOGINNEED_ACTION;
    
    kSelfWeak;
    [self.textBook textBookCollectBookComplete:^(BOOL isSuccess) {
        if (isSuccess) {
            self.textBook.isCollect = !self.textBook.isCollect;
            
            NSString *message = self.textBook.isCollect ? @"收藏成功!" : @"取消收藏成功!";
            [weakSelf showText:message inView:weakSelf.navigationController.view];
            
            [weakSelf configNavBarWithCollected];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TEXT_BOOK_REFRESH object:nil userInfo:@{TEXT_BOOK_ID:weakSelf.textBook.idd}];
        }
    }];
}

#pragma mark - 书籍详情数据请求

-(void)textBookMessageRequest
{
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.textBook.idd.length < 1) {
        [self showTextWithState:ActivityHUDStateFailed inView:self.navigationController.view text:@"很抱歉/n该书籍已下架或不存在！"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [param setObject:self.textBook.idd forKey:@"textBookId"];
    
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfThree param:param] requestType:RequestTypeOfZhuiShu params:nil completion:^(NSDictionary *responseObject) {
        if (responseObject.count > 0)
        {
            weakSelf.textDetail = [TextBookDetail toTextBookDetail:responseObject];
            weakSelf.headerView.detail = weakSelf.textDetail;
            [weakSelf.tableView reloadData];
            
            // 获取评论数据
            [weakSelf textBookCommentsRequest];
            // 推荐书单
            [weakSelf textBookListRequest];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 书籍评论数据请求

-(void)textBookCommentsRequest
{
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:self.textBook.idd forKey:@"book"];
    
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:UrlTypeOfFour param:nil] requestType:RequestTypeOfZhuiShu params:param completion:^(NSDictionary *responseObject) {
        if (SUCCESS_OK)
        {
            weakSelf.reviewAry = [[TextReviewModel toTextReviewModelAry:responseObject[@"reviews"]] mutableCopy];
            weakSelf.handleReviewAry = [[TextReviewModel toSDTimeLineModelAry:weakSelf.reviewAry] mutableCopy];
            
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 推荐书单数据获取

-(void)textBookListRequest
{
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:self.textBook.idd forKey:@"textBookId"];
    // 默认查六条推荐书单
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfFive param:param] requestType:RequestTypeOfZhuiShu params:@{@"limit":@(6)} completion:^(NSDictionary *responseObject) {
        if (SUCCESS_OK)
        {
            weakSelf.recommendAry = [[RecommendBookModel toRecommendBookAry:responseObject[@"booklists"]] mutableCopy];
            
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.handleReviewAry.count;
    }else if (section == 2){
        return self.recommendAry.count;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        // 热门评论数据
        SDTimeLineCellModel *model = self.handleReviewAry[indexPath.row];
        SDTimeLineBaseCell *timeLine = [SDTimeLineBaseCell SDTimeLineCell:tableView model:self.handleReviewAry[indexPath.row]];
        timeLine.indexPath = indexPath;
        timeLine.delegate = self;
        // 高度缓存
        [timeLine useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        timeLine.model = model;
        return timeLine;
    }
    else if (indexPath.section == 2)
    {
        RecomendTextBookCell *recomend = [RecomendTextBookCell recomendCell:tableView];
        recomend.recommentBook = self.recommendAry[indexPath.row];
        return recomend;
    }
    else
    {
        /**
         *  第一节
         */
        if (indexPath.row == 0)
        {
            // 书籍简介
            UITableViewCell *product = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            product.textLabel.numberOfLines = 0;
            product.textLabel.textColor = [UIColor grayColor];
            product.textLabel.font = [UIFont systemFontOfSize:15];
            NSString *message = [NSString stringWithFormat:@"%@",self.textDetail? self.textDetail.longIntro : self.textBook.shortIntro];
            product.textLabel.text = message;
            return product;
        }
        else
        {
            // 标签区域
            UITableViewCell *tagCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            for (UIView *subView in tagCell.contentView.subviews)
            {
                [subView removeFromSuperview];
            }
            //单行不需要设置高度,内部根据初始化参数自动计算高度
            HXTagsView *tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
            tagsView.type = 1;
            [tagsView setTagAry:self.textDetail.tags delegate:self];
            [tagCell.contentView addSubview:tagsView];
            return tagCell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (self.handleReviewAry.count < 1) {
            return 20;
        }
        SDTimeLineCellModel *model = self.handleReviewAry[indexPath.row];
        Class cellClass = [SDTimeLineImageCell class];
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:cellClass contentViewWidth:[self cellContentViewWith]];
    }
    else if (indexPath.section == 2)
    {
        return 110.f;
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 50.f;
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 40.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    if (section != 0)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 24, 40)];
        [labTitle setTextColor:THEME_COLOR];
        labTitle.font = [UIFont systemFontOfSize:15.f];
        [headerView addSubview:labTitle];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5f, SCREEN_WIDTH, 0.5f)];
        bottomLine.backgroundColor = LINE_COLOR;
        [headerView addSubview:bottomLine];
        
        if (section == 1) {
            labTitle.text = [NSString stringWithFormat:@"热门评论（%ld）",self.handleReviewAry.count];
        }
        else if (section == 2){
            labTitle.text = [NSString stringWithFormat:@"推荐书单（%ld）",self.recommendAry.count];
        }
    }
    return headerView;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 2)
    {
        // 推荐书单
        RecommendBookModel *recommend = self.recommendAry[indexPath.row];
        
        BookTextThemeListController *themeList = [[BookTextThemeListController alloc] initWithStyle:UITableViewStyleGrouped];
        themeList.recommend = recommend;
        themeList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:themeList animated:YES];
    }
}

#pragma mark - SDTimeLineBaseCellDelegate代理

-(void)didClickTopHeaderViewInCell:(SDTimeLineBaseCell *)cell circleHeaderViewAction:(CircleHeaderViewActionType)type
{
    TextReviewModel *model = self.reviewAry[cell.indexPath.row];
    
    if (type == CircleHeaderViewActionOfIcon || type == CircleHeaderViewActionOfName)
    {
        PersonalCenterController *personVC = [[PersonalCenterController alloc] init];
        personVC.author = model.author;
        personVC.appType = AppApiTypeOfZhuiShu;
        [self.navigationController pushViewController:personVC animated:YES];
    }
    else if (type == CircleHeaderViewActionOfTextContent)
    {
        //[self showText:@"文本内容" inView:self.navigationController.view];
    }
}

-(void)didClickDescriptionMenuInCell:(SDTimeLineBaseCell *)cell opeartionMenu:(OperationMenu)menu
{
    TextReviewModel *model = self.reviewAry[cell.indexPath.row];
    SDTimeLineCellModel *timeLineModel = self.handleReviewAry[cell.indexPath.row];
    
    if (menu == OperationMenuOfDelete)
    {
        LOGINNEED_ACTION
        
        [self.handleReviewAry removeObjectAtIndex:cell.indexPath.row];
        [self.reviewAry removeObjectAtIndex:cell.indexPath.row];
        [self.tableView reloadData];
    }
    else if (menu == OperationMenuOfComment) {
       // 评论
        [self showTextWithState:ActivityHUDStateFailed inView:self.navigationController.view text:@"很抱歉\n数据好像出错了!"];
    }
    else if (menu == OperationMenuOfDianZan) {
        
        LOGINNEED_ACTION
        
        timeLineModel.liked = !timeLineModel.liked;
        timeLineModel.likesCount = [NSString stringWithFormat:@"%ld",[timeLineModel.likesCount integerValue] + 1];
        model.likeCount += 1;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)didClickLinkActionInCell:(SDTimeLineBaseCell *)cell type:(MLEmojiLabelLinkType)type link:(NSString *)link linkValue:(NSString *)linkValue
{
    TextReviewModel *model = self.dataSource[cell.indexPath.row];
    
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
        personVC.author = model.author;
        personVC.appType = AppApiTypeOfZhuiShu;
        [self.navigationController pushViewController:personVC animated:YES];
    }
}

-(void)didClickMoreBtnInCell:(SDTimeLineBaseCell *)cell
{
    NSIndexPath *indexPath = cell.indexPath;
    SDTimeLineCellModel *model = self.handleReviewAry[indexPath.row];
    model.isOpening = !model.isOpening;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 懒加载

-(BookTextHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [BookTextHeaderView bookTextHeader];
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - 分享视图

-(void)headerViewDidClickShare
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

#pragma mark - 阅读小说

-(void)headerViewDidClickReader
{
    CBReaderPageController *CBReader = [[CBReaderPageController alloc] init];
    CBReader.textBookId = self.textBook.idd;
    [self presentViewController:CBReader animated:YES completion:nil];
}

#pragma mark - 章节列表页面

-(void)headerViewDidClickMenu
{
    BookTextListViewController *textList = [[BookTextListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    textList.textBookId = self.textBook.idd;
    textList.type = BookTextListTypeOfSummary;
    textList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:textList animated:YES];
}


@end
