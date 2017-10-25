//
//  BookReviewListController.m
//  MoreAndMore
//
//  Created by apple on 16/10/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookReviewListController.h"

#import "BookTextDetailController.h"

#import "SGTopScrollMenu.h"
#import "ZXMenuListView.h"

#import "ReviewBookCell.h"

@interface BookReviewListController ()<SGTopScrollMenuDelegate,UITableViewDataSource,UITableViewDelegate,ZXMenuListViewDelegate>

@property (nonatomic,weak)SGTopScrollMenu *topMenu;

@property (nonatomic,weak)UITableView *tableView;

//  当前页数
@property (nonatomic,assign)NSInteger currentPage;

// 筛选参数
@property (nonatomic,assign)NSInteger menuOneIndex;

@property (nonatomic,assign)NSInteger menuTwoIndex;

@property (nonatomic,assign)NSInteger menuThreeIndex;

@property (nonatomic,strong)NSArray *menuTitleList;
@property (nonatomic,strong)NSArray *menuTagList;

// 0：全部/精华   1：类型   2：排序
@property (nonatomic,assign)NSInteger currentShowMenu;

@end

@implementation BookReviewListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"书评区";
    
    // 筛选数据
    self.menuTitleList = @[@[@"全部",@"精品"],
                           @[@"全部类型",
                             @"玄幻奇幻",
                             @"武侠仙侠",
                             @"都市异能",
                             @"历史军事",
                             @"游戏竞技",
                             @"科幻灵异",
                             @"穿越架空",
                             @"豪门总裁",
                             @"现代言情",
                             @"古代言情",
                             @"幻想言情",
                             @"耿美同人"],
                           @[@"默认排序",
                             @"最新发布",
                             @"最有用的",
                             @"最多评论"]];
    /*
     distillate = ?
     type = ?
     sort = ?
     */
    self.menuTagList = @[@[@"false",
                           @"true"],
                         @[@"all",
                           @"xhqh",
                           @"wxxx",
                           @"dsyn",
                           @"lsjs",
                           @"yxjj",
                           @"khly",
                           @"cyjk",
                           @"hmzc",
                           @"xdyq",
                           @"gdyq",
                           @"hxyq",
                           @"gmtr"],
                         @[@"updated",
                           @"created",
                           @"helpful",
                           @"comment-count"]];
    
    self.menuOneIndex = 0;
    self.menuTwoIndex = 0;
    self.menuThreeIndex = 0;
    
    [self initContentView];
}

-(void)initContentView
{
    self.currentPage = 0;
    
    CGFloat menuHei = 40;
    // 顶部筛选菜单
    SGTopScrollMenu *topMenu = [SGTopScrollMenu topScrollMenuWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, menuHei)];
    topMenu.backgroundColor = [UIColor whiteColor];
    topMenu.titlesArr = @[
                          [self.menuTitleList[0][self.menuOneIndex] stringByAppendingString:@"▽"],
                          [self.menuTitleList[1][self.menuTwoIndex]stringByAppendingString:@"▽"],
                          [self.menuTitleList[2][self.menuThreeIndex] stringByAppendingString:@"▽"]] ;
    topMenu.topScrollMenuDelegate = self;
    [self.view addSubview:topMenu];
    self.topMenu = topMenu;
    
    // 表格区域
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, menuHei, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - menuHei) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 50.f;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.separatorColor = LINE_COLOR;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
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
    [param setObject:@"all" forKey:@"duration"];
    // 筛选参数
    // 第一列
    if (self.menuOneIndex != 0)
    {
        [param setObject:@"true" forKey:@"distillate"];
    }
    // 第二列
    [param setObject:self.menuTagList[1][self.menuTwoIndex] forKey:@"type"];
    // 第三列
    [param setObject:self.menuTagList[2][self.menuThreeIndex] forKey:@"sort"];
    
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfTwelve param:nil] requestType:RequestTypeOfZhuiShu params:param completion:^(NSDictionary *responseObject) {
        ActivityHUDState state = ActivityHUDStateFailed;
        NSString *resultMes = REQUESTTIPFAI;
        if (SUCCESS_OK)
        {
            state = ActivityHUDStateSuccess;
            resultMes = REQUESTTIPSUC;

            NSMutableArray *newAry = [BookReviewModel toBookReviewModelAry:responseObject[@"reviews"]];
            
            if (newAry.count > 0)
            {
                if (weakSelf.tableView.mj_header == refreshView || self.currentPage == 0)
                {
                    [weakSelf.dataSource removeAllObjects];
                }
                
                weakSelf.currentPage += newAry.count;
                
                [weakSelf.dataSource addObjectsFromArray:newAry];
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
    NSArray *menuAry = self.menuTitleList[index];
    NSInteger myIndex = 0;
    
    if (index == 0)
    {
        myIndex = self.menuOneIndex;
    }
    else if (index == 1)
    {
        myIndex = self.menuTwoIndex;
    }
    else if (index == 2)
    {
        myIndex = self.menuThreeIndex;
    }
    
    self.currentShowMenu = index;
    
    ZXMenuListView *menuList = [ZXMenuListView menuWithTitleAry:menuAry index:myIndex];
    menuList.delegate = self;
    
    [menuList showOrHiidenMenuView:NO offsetY:64 + 40];
}

#pragma mark - ZXMenuListViewDelegate

-(void)resultListViewDidSelectRow:(NSInteger)index
{
    self.currentPage = 0;
    
    BOOL showReload = NO;
    
    if (self.currentShowMenu == 0 && self.menuOneIndex != index) {
        self.menuOneIndex = index;
        showReload = YES;
    }else if (self.currentShowMenu == 1 && self.menuTwoIndex != index){
        self.menuTwoIndex = index;
        showReload = YES;
    }else if (self.currentShowMenu == 2 && self.menuThreeIndex != index){
        self.menuThreeIndex = index;
        showReload = YES;
    }
    
    UILabel *label = self.topMenu.allTitleLabel[self.currentShowMenu];
    [label setText:[self.menuTitleList[self.currentShowMenu][index] stringByAppendingString:@"▽"]];
    
    if (showReload) {
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)cancelListView
{
    NSLog(@"取消了！");
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookReviewModel *reviewModel = self.dataSource[indexPath.section];
    
    if (indexPath.row == 0)
    {
        ReviewBookCell *reviewCell = [ReviewBookCell reviewCell:tableView];
        reviewCell.reviewModel = reviewModel;
        return reviewCell;
    }
    else
    {
        static NSString *iden = @"REVIEW_DESC";
        
        UITableViewCell *desCell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!desCell) {
            desCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
            desCell.textLabel.numberOfLines = 0;
            desCell.textLabel.font = [UIFont systemFontOfSize:15];
            desCell.textLabel.textColor = [UIColor grayColor];
        }
        desCell.textLabel.text = reviewModel.title;
        return desCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80.f;
    }
    
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BookReviewModel *reviewModel = self.dataSource[indexPath.section];
    
    BookTextDetailController *textBook = [[BookTextDetailController alloc] initWithStyle:UITableViewStyleGrouped];
    textBook.textBook = [reviewModel toTextBook];
    textBook.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:textBook animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
