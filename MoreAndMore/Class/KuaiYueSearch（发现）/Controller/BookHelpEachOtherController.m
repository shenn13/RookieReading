//
//  BookHelpEachOtherController.m
//  MoreAndMore
//
//  Created by apple on 16/10/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookHelpEachOtherController.h"

#import "PublicWebController.h"
#import "PersonalCenterController.h"
#import "PostHelpEachOtherController.h"

#import "SGTopScrollMenu.h"
#import "TextReviewModel.h"

#import "SDTimeLineImageCell.h"

@interface BookHelpEachOtherController ()<SGTopScrollMenuDelegate,UITableViewDataSource,UITableViewDelegate,SDTimeLineBaseCellDelegate,PostHelpEachOtherDelelgate>

@property (nonatomic,assign)NSInteger currentPage;

@property (nonatomic,weak)SGTopScrollMenu *topMenu;

@property (nonatomic,weak)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *handleReviewAry;

@end

@implementation BookHelpEachOtherController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"书荒互助";

    [self initContentView];
}

-(void)setMenuIndex:(NSInteger)menuIndex
{
    _menuIndex = menuIndex;
    
    self.currentPage = 0;
}

-(void)initContentView
{
    self.currentPage = 0;
    
    CGFloat menuHei = 40;
    // 顶部筛选菜单
    SGTopScrollMenu *topMenu = [SGTopScrollMenu topScrollMenuWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, menuHei)];
    topMenu.backgroundColor = [UIColor whiteColor];
    topMenu.titlesArr = @[@"全部",@"精品"];
    topMenu.topScrollMenuDelegate = self;
    [self.view addSubview:topMenu];
    self.topMenu = topMenu;
    
    // 表格区域
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, menuHei, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - menuHei) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 100.f;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.separatorColor = LINE_COLOR;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 注册重用标志
    [self.tableView registerClass:[SDTimeLineImageCell class] forCellReuseIdentifier:kSDTIMELINE_IMAGE];
    
    kSelfWeak;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        [weakSelf initWithCatRequest:weakSelf.tableView.mj_header];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf initWithCatRequest:weakSelf.tableView.mj_footer];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[@"tweetBtn_Nav"] selArr:nil];
}

-(void)rightBarItemClick:(UIButton *)rightItem
{
    PostHelpEachOtherController *help = BoardVCWithID(@"JingXuan", @"POSTHELP_EACHOTHER");
    help.isReply = NO;
    help.placeHolder = @"请输入书荒求助标题！";
    help.delegate = self;
    help.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:help animated:YES];
}

-(void)zhuiShuPostComment:(TextReviewModel *)reviewModel
{
    if (reviewModel)
    {
        [self.dataSource insertObject:reviewModel atIndex:0];
        SDTimeLineCellModel *model = [[TextReviewModel toSDTimeLineModelAry:@[reviewModel]] firstObject];
        model.showDel = YES;
        [self.handleReviewAry insertObject:model atIndex:0];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 数据请求

-(void)initWithCatRequest:(MJRefreshComponent *)refreshView
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (refreshView == nil) {
        [self startActivityWithText:REQUESTTIPING];
    }
    
    // 当前页码
    [param setObject:@(self.currentPage) forKey:@"start"];
    [param setObject:PAGESIZE20 forKey:@"limit"];
    // 筛选参数
    [param setObject:@"updated" forKey:@"sort"];
    [param setObject:@"all" forKey:@"duration"];
    if (self.menuIndex == 1)
    {
        [param setObject:@"true" forKey:@"distillate"];
    }
    
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfThirteen param:nil] requestType:RequestTypeOfZhuiShu params:param completion:^(NSDictionary *responseObject) {
        ActivityHUDState state = ActivityHUDStateFailed;
        NSString *resultMes = REQUESTTIPFAI;
        if (SUCCESS_OK)
        {
            state = ActivityHUDStateSuccess;
            resultMes = REQUESTTIPSUC;
            
            NSMutableArray *newAry = [[TextReviewModel toTextReviewModelAry:responseObject[@"helps"]] mutableCopy];
            
            if (newAry.count > 0)
            {
                if (weakSelf.tableView.mj_header == refreshView || self.currentPage == 0)
                {
                    [weakSelf.dataSource removeAllObjects];
                    [weakSelf.handleReviewAry removeAllObjects];
                }
                
                weakSelf.currentPage += newAry.count;
                
                [weakSelf.dataSource addObjectsFromArray:newAry];
                // 处理数据
                [weakSelf.handleReviewAry addObjectsFromArray:[TextReviewModel toSDTimeLineModelAry:weakSelf.dataSource]];
            }
            
            [weakSelf.tableView reloadData];
        }
        if ([refreshView isRefreshing])
        {
            [refreshView endRefreshing];
        }
        [weakSelf stopActivityWithText:resultMes state:state];
    } failure:^(NSError *error) {
        if ([refreshView isRefreshing])
        {
            [refreshView endRefreshing];
        }
        [weakSelf stopActivityWithText:nil state:ActivityHUDStateFailed];
    }];
}

#pragma mark - 筛选切换（主题书单）
-(void)SGTopScrollMenu:(SGTopScrollMenu *)topScrollMenu didSelectTitleAtIndex:(NSInteger)index
{
    if (self.menuIndex != index)
    {
        self.menuIndex = index;
        
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.handleReviewAry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 热门评论数据
    SDTimeLineCellModel *model = self.handleReviewAry[indexPath.section];
    SDTimeLineBaseCell *timeLine = [SDTimeLineBaseCell SDTimeLineCell:tableView model:self.handleReviewAry[indexPath.section]];
    timeLine.indexPath = indexPath;
    timeLine.delegate = self;
    // 高度缓存
    [timeLine useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    timeLine.model = model;
    return timeLine;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.handleReviewAry.count < 1) {
        return 20;
    }
    SDTimeLineCellModel *model = self.handleReviewAry[indexPath.section];
    Class cellClass = [SDTimeLineImageCell class];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:cellClass contentViewWidth:[self cellContentViewWith]];
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


#pragma mark - SDTimeLineBaseCellDelegate代理

-(void)didClickTopHeaderViewInCell:(SDTimeLineBaseCell *)cell circleHeaderViewAction:(CircleHeaderViewActionType)type
{
    LOGINNEED_ACTION;
    
    TextReviewModel *model = self.dataSource[cell.indexPath.section];
    
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
    LOGINNEED_ACTION
    
    TextReviewModel *model = self.dataSource[cell.indexPath.section];
    SDTimeLineCellModel *timeLineModel = self.handleReviewAry[cell.indexPath.section];
    
    if (menu == OperationMenuOfDelete)
    {
        [self.handleReviewAry removeObjectAtIndex:cell.indexPath.section];
        [self.dataSource removeObjectAtIndex:cell.indexPath.section];
        [self.tableView reloadData];
    }
    else if (menu == OperationMenuOfComment) {
        // 书荒求助
        PostHelpEachOtherController *help = BoardVCWithID(@"JingXuan", @"POSTHELP_EACHOTHER");
        help.isReply = YES;
        help.placeHolder = [NSString stringWithFormat:@"回复@%@:",model.author.nickname];
        help.reviewModel = model;
        help.delegate = self;
        help.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:help animated:YES];
        //[self showTextWithState:ActivityHUDStateFailed inView:self.navigationController.view text:@"很抱歉\n数据好像出错了!"];
    }
    else if (menu == OperationMenuOfDianZan) {
        
        timeLineModel.liked = !timeLineModel.liked;
        timeLineModel.likesCount = [NSString stringWithFormat:@"%ld",[timeLineModel.likesCount integerValue] + 1];
        model.likeCount += 1;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)didClickLinkActionInCell:(SDTimeLineBaseCell *)cell type:(MLEmojiLabelLinkType)type link:(NSString *)link linkValue:(NSString *)linkValue
{
    LOGINNEED_ACTION;
    
    TextReviewModel *model = self.dataSource[cell.indexPath.section];
    
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
    SDTimeLineCellModel *model = self.handleReviewAry[indexPath.section];
    model.isOpening = !model.isOpening;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSMutableArray *)handleReviewAry
{
    if (!_handleReviewAry) {
        _handleReviewAry = [NSMutableArray arrayWithCapacity:0];
    }
    return _handleReviewAry;
}

@end
