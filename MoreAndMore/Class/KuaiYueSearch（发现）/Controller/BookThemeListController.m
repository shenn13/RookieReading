//
//  BookThemeListController.m
//  MoreAndMore
//
//  Created by apple on 16/10/2.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookThemeListController.h"
#import "BookTextThemeListController.h"

#import "SGTopScrollMenu.h"

#import "RecomendTextBookCell.h"

@interface BookThemeListController ()<SGTopScrollMenuDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak)SGTopScrollMenu *topMenu;

@property (nonatomic,weak)UITableView *tableView;

//  当前页数
@property (nonatomic,assign)NSInteger currentPage;

//  当前筛选参数
@property (nonatomic,copy)NSString *duration;
@property (nonatomic,copy)NSString *sort;

@end

@implementation BookThemeListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"主题书单";
    
    [self initContentView];
}

-(void)setMenuIndex:(NSInteger)menuIndex
{
    _menuIndex = menuIndex;
    
    self.currentPage = 0;
    
    if (menuIndex == 0)
    {
        self.duration = @"last-seven-days";
        self.sort = @"collectorCount";
    }
    else if (menuIndex == 1)
    {
        self.duration = @"all";
        self.sort = @"created";
    }
    else if (menuIndex == 2)
    {
        self.duration = @"all";
        self.sort = @"collectorCount";
    }
}

-(void)initContentView
{
    self.currentPage = 0;
    
    CGFloat menuHei = 40;
    // 顶部筛选菜单
    SGTopScrollMenu *topMenu = [SGTopScrollMenu topScrollMenuWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, menuHei)];
    topMenu.backgroundColor = [UIColor whiteColor];
    /*
     sort=collectorCount&duration=last-seven-days
     sort=created&duration=all
     sort=collectorCount&duration=all
     */
    topMenu.titlesArr = @[@"本周最热",@"最新发布",@"更多收藏"];
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
    // 筛选参数
    [param setObject:self.sort forKey:@"sort"];
    [param setObject:self.duration forKey:@"duration"];
    
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfEleven param:nil] requestType:RequestTypeOfZhuiShu params:param completion:^(NSDictionary *responseObject) {
        ActivityHUDState state = ActivityHUDStateFailed;
        NSString *resultMes = REQUESTTIPFAI;
        if (SUCCESS_OK)
        {
            state = ActivityHUDStateSuccess;
            resultMes = REQUESTTIPSUC;

            NSMutableArray *newAry = [RecommendBookModel toRecommendBookAry2:responseObject[@"bookLists"]];

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
    if (self.menuIndex != index)
    {
        self.menuIndex = index;
        
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecomendTextBookCell *themeCell = [RecomendTextBookCell recomendCell:tableView];
    themeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    themeCell.recommentBook = self.dataSource[indexPath.section];
    return themeCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 推荐书单
    RecommendBookModel *recommend = self.dataSource[indexPath.section];
    
    BookTextThemeListController *themeList = [[BookTextThemeListController alloc] initWithStyle:UITableViewStyleGrouped];
    themeList.recommend = recommend;
    themeList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:themeList animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
