//
//  BookImageListFilterController.m
//  MoreAndMore
//
//  Created by apple on 16/10/2.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookImageListFilterController.h"
#import "BookDetailViewController.h"

#import "SGTopScrollMenu.h"
#import "MoreTopicCell.h"

#import "Topic.h"

@interface BookImageListFilterController ()<SGTopScrollMenuDelegate,UITableViewDataSource,UITableViewDelegate,MoreTopicCellDelegate>

@property (nonatomic,weak)SGTopScrollMenu *topMenu;

// 固定筛选数据源(顶部菜单)
@property (nonatomic,strong)NSArray *topMenuAry;

@property (nonatomic,weak)UITableView *tableView;

// 当前查询页
@property (nonatomic,assign)NSInteger currentPage;

@end

@implementation BookImageListFilterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 筛选数据源
    self.topMenuAry = @[@"全部",@"恋爱",@"爆笑",@"奇幻",@"恐怖",@"耿美",@"剧情",@"成人",@"日常",@"治愈",@"百合",@"三次元"];
    
    // 界面内容
    [self initContentView];
    
    // 监听通知
    [self configNotification];
}

-(void)setMenuModel:(TextMenuModel *)menuModel
{
    _menuModel = menuModel;
    
    self.navigationItem.title = menuModel.name;
    
    self.currentPage = 0;
}

#pragma mark - 初始化界面

-(void)initContentView
{
    CGFloat menuHei = 40;
    // 顶部筛选菜单
    SGTopScrollMenu *topMenu = [SGTopScrollMenu topScrollMenuWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, menuHei)];
    topMenu.backgroundColor = [UIColor whiteColor];
    topMenu.titlesArr = self.topMenuAry;
    topMenu.topScrollMenuDelegate = self;
    [self.view addSubview:topMenu];
    self.topMenu = topMenu;
    
    // 选中默认的标签
    [self.topMenu selectLabel:self.topMenu.allTitleLabel[self.menuIndex]];
    [self.topMenu setupTitleCenter:self.topMenu.allTitleLabel[self.menuIndex]];
    
    // 表格区域
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, menuHei, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - menuHei) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    kSelfWeak;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        [weakSelf initWithRequest:weakSelf.tableView.mj_header];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf initWithRequest:weakSelf.tableView.mj_footer];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 数据请求

-(void)initWithRequest:(MJRefreshComponent *)refreshView
{
    if (!self.menuModel) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [param setObject:PAGESIZE20 forKey:@"count"];
    [param setObject:@(self.currentPage) forKey:@"since"];
    
    [param setObject:self.menuModel.imgMenuId forKey:@"tag"];
    
    kSelfWeak;
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    [request baseRequestWithMethod:[request v2GetMethodWithType:URLTypeOfSeven param:nil] requestType:RequestTypeOfKuaiKan params:param completion:^(NSDictionary *responseObject) {
        if (SUCCESS)
        {
            NSMutableArray *dataAry = [[Topic toTopicsArr:responseObject[@"data"][@"topics"]] mutableCopy];
            if (dataAry.count > 0)
            {
                if (weakSelf.tableView.mj_header == refreshView || self.currentPage == 0)
                {
                    [weakSelf.dataSource removeAllObjects];
                }
                
                weakSelf.currentPage += dataAry.count;
                
                [weakSelf.dataSource addObjectsFromArray:dataAry];
            }
            else
            {
                [weakSelf showTextWithState:ActivityHUDStateFailed inView:weakSelf.view text:@"没有更多数据了!"];
            }
            [weakSelf.tableView reloadData];
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

#pragma mark - 筛选数据

-(void)SGTopScrollMenu:(SGTopScrollMenu *)topScrollMenu didSelectTitleAtIndex:(NSInteger)index
{
    if (self.menuIndex != index && self.menuAry.count > index)
    {
        self.menuIndex = index;
        self.menuModel = self.menuAry[index];
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - 注册通知相关

-(void)configNotification
{
    kSelfWeak;
    
    // 书籍列表刷新事件(图书)
    [[NSNotificationCenter defaultCenter] addObserverForName:IMAGE_BOOK_REFRESH object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * note) {
        NSString *IDD = note.userInfo[IMAGE_BOOK_ID];
        for (Topic *topic in weakSelf.dataSource)
        {
            if ([topic.idd isEqualToString:IDD])
            {
                NSInteger index = [weakSelf.dataSource indexOfObject:topic];
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
    MoreTopicCell *topicCell = [MoreTopicCell moreTopicCell:tableView];
    topicCell.indexPath = indexPath;
    topicCell.delegate = self;
    topicCell.topic = self.dataSource[indexPath.row];
    return topicCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Topic *topic = self.dataSource[indexPath.row];
    topic.order = 0; // 默认倒序排序（即最新章节在最前面)
    BookDetailViewController *bookDetail = [[BookDetailViewController alloc] init];
    bookDetail.book = topic;
    bookDetail.hidesBottomBarWhenPushed = YES;
    [JUMP_MANAGER.jumpNavigation pushViewController:bookDetail animated:YES];
}

#pragma mark - 收藏或取消收藏(图书)

-(void)moreTopic:(MoreTopicCell *)moreCell didClickCollect:(Topic *)topic
{
    kSelfWeak;
    
    __block Topic *data_topic = self.dataSource[moreCell.indexPath.row];
    if (!data_topic) return;
    
    [data_topic topicCollectBookComplete:^(BOOL isSuccess) {
        if (isSuccess) {
            data_topic.is_favourite = !data_topic.is_favourite;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[moreCell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            NSString *message = data_topic.is_favourite ? @"收藏成功!" : @"取消收藏成功!";
            [weakSelf showText:message inView:weakSelf.navigationController.view];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
