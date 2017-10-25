//
//  BookTextListFilterController.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextListFilterController.h"
#import "BookTextDetailController.h"

#import "SGTopScrollMenu.h"
#import "ZXMenuListView.h"

#import "BookTextMoreCell.h"

@interface BookTextListFilterController ()<UITableViewDataSource,UITableViewDelegate,SGTopScrollMenuDelegate,BookTextMoreCellDelegate,ZXMenuListViewDelegate>

@property (nonatomic,weak)SGTopScrollMenu *topMenu;

@property (nonatomic,weak)UITableView *tableView;

@property (nonatomic,strong)NSArray *types;
/**
 *  当前选中的筛选索引
 */
@property (nonatomic,assign)NSInteger typeIndex;

@property (nonatomic,assign)NSInteger currentPage;

/**
 *  子分类名
 */
@property (nonatomic,copy)NSString *minor;

@property (nonatomic,strong)ZXMenuListView *listView;

@end

@implementation BookTextListFilterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.menuModel.name;

    // 界面内容
    [self initContentView];
    
    // 监听通知
    [self configNotification];
}

-(void)setMenuModel:(TextMenuModel *)menuModel
{
    _menuModel = menuModel;
    
    if (menuModel.mins.count > 0)
    {
        self.menuList = [NSMutableArray arrayWithCapacity:0];
        [self.menuList addObject:@"全部"];
        [self.menuList addObjectsFromArray:menuModel.mins];
    }
}

#pragma mark - 数据请求

-(void)initWithCatRequest:(MJRefreshComponent *)refreshView;
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    if (!self.menuModel)
    {
        [self showTextWithState:ActivityHUDStateFailed inView:self.view text:@"很抱歉\n该书籍分类不存在或已被删除！"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    };
    
    if (refreshView == nil) {
        [self startActivityWithText:REQUESTTIPING];
    }
    
    // 筛选类型
    [param setObject:self.types[self.typeIndex] forKey:@"type"];
    // 性别
    NSString *gender;
    if (self.menuModel.gender == GenderTypeOfMale) {
        gender = @"male";
    }else if (self.menuModel.gender == GenderTypeOfFemale) {
        gender = @"female";
    }else if (self.menuModel.gender == GenderTypeOfPress) {
        gender = @"press";
    }
    if (gender.length > 0) {
        [param setObject:gender forKey:@"gender"];
    }
    // 分类名
    if (self.menuModel.name.length > 0) {
        [param setObject:self.menuModel.name forKey:@"major"];
    }
    // 分页请求
    [param setObject:@(20) forKey:@"limit"];
    // 当前页码
    [param setObject:@(self.currentPage) forKey:@"start"];
    // 子分类
    [param setObject:self.minor ? self.minor : @"" forKey:@"minor"];

    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfTen param:nil] requestType:RequestTypeOfZhuiShu params:param completion:^(NSDictionary *responseObject) {
        ActivityHUDState state = ActivityHUDStateFailed;
        NSString *resultMes = REQUESTTIPFAI;
        if (SUCCESS_OK)
        {
            state = ActivityHUDStateSuccess;
            resultMes = REQUESTTIPSUC;
            NSArray *newAry = [TextBook toTextBookAry:responseObject[@"books"]];
            if (newAry.count > 0)
            {
                if (weakSelf.tableView.mj_header == refreshView || self.currentPage == 0)
                {
                    [weakSelf.dataSource removeAllObjects];
                }
                
                // 检查数据是否已经被收藏
                for (TextBook *textBook in newAry)
                {
                    // 查看是否已经被收藏
                    [textBook checkItCollected];
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

#pragma mark - 初始化界面

-(void)initContentView
{
    self.types = @[@"hot",@"new",@"reputation",@"over"];
    self.typeIndex = 0;
    self.currentPage = 0;
    
    CGFloat menuHei = 40;
    // 顶部筛选菜单
    SGTopScrollMenu *topMenu = [SGTopScrollMenu topScrollMenuWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, menuHei)];
    topMenu.backgroundColor = [UIColor whiteColor];
    topMenu.titlesArr = @[@"最新",@"最热",@"好评",@"完结"];
    topMenu.topScrollMenuDelegate = self;
    [self.view addSubview:topMenu];
    self.topMenu = topMenu;
    
    // 表格区域
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, menuHei, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - menuHei) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 120.f;
    tableView.backgroundColor = [UIColor whiteColor];
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
    
    // 子分类按钮（导航栏右边）
    if (self.menuModel.mins.count > 0)
    {
        [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[@"menu_list"] selArr:nil];
    }
}

#pragma mark - 筛选子分类书籍

-(void)rightBarItemClick:(UIButton *)rightItem
{
    [self.listView showOrHiidenMenuView:NO offsetY:64];
}

#pragma mark - 注册通知相关

-(void)configNotification
{
    kSelfWeak;
    
    // 书籍列表刷新事件（文字）
    [[NSNotificationCenter defaultCenter] addObserverForName:TEXT_BOOK_REFRESH object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * note) {
        NSString *IDD = note.userInfo[TEXT_BOOK_ID];
        for (TextBook *textBook in weakSelf.dataSource)
        {
            if ([textBook.idd isEqualToString:IDD])
            {
                NSInteger index = [weakSelf.dataSource indexOfObject:textBook];
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextBook *book = self.dataSource[indexPath.row];
    
    BookTextMoreCell *moreCell = [BookTextMoreCell textMoreCell:tableView];
    moreCell.textBook = book;
    moreCell.indexPath = indexPath;
    moreCell.delegate = self;
    return moreCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BookTextDetailController *textDetail = [[BookTextDetailController alloc] initWithStyle:UITableViewStyleGrouped];
    textDetail.textBook = self.dataSource[indexPath.row];
    textDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:textDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - ZXMenuListViewDelegate

-(void)resultListViewDidSelectRow:(NSInteger)index
{
    NSString *newMinor = self.menuList[index];
    
    if (![newMinor isEqualToString:self.minor])
    {
        self.minor = self.menuList[index];
        
        self.navigationItem.title = self.minor;
        
        if (index == 0) {
            self.minor = @"";
            self.navigationItem.title = self.menuModel.name;
        }
        // 子分类筛选
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)cancelListView
{
    NSLog(@"取消筛选!");
}

#pragma mark - 筛选数据

-(void)SGTopScrollMenu:(SGTopScrollMenu *)topScrollMenu didSelectTitleAtIndex:(NSInteger)index
{
    self.tableView.contentOffset = CGPointZero;
    if (index != self.typeIndex)
    {
        self.typeIndex = index;
        self.currentPage = 0;
        [self initWithCatRequest:nil];
    }
}

#pragma mark - 收藏或取消收藏(文字)
-(void)moreTextBook:(BookTextMoreCell *)moreCell didClickCollect:(TextBook *)textBook
{
    kSelfWeak;
    
    __block TextBook *myBook = self.dataSource[moreCell.indexPath.row];
    if (!myBook) return;
    
    [myBook textBookCollectBookComplete:^(BOOL isSuccess) {
        if (isSuccess) {
            myBook.isCollect = !textBook.isCollect;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[moreCell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            NSString *message = myBook.isCollect ? @"收藏成功!" : @"取消收藏成功!";
            [weakSelf showText:message inView:weakSelf.navigationController.view];
        }
    }];
}

-(ZXMenuListView *)listView
{
    if (!_listView) {
        _listView = [ZXMenuListView menuWithTitleAry:self.menuList index:0];
        _listView.delegate = self;
    }
    return _listView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
