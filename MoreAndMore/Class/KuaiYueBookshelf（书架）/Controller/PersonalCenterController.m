//
//  PersonalCenterController.m
//  topLicaiPro
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import "PersonalCenterController.h"
#import "BookDetailViewController.h"

#import "PersonHeaderView.h"
#import "FilterHeaderView.h"
#import "TopicUserCenterCell.h"

#import "ZXRequestTool.h"

#import "KuaiKanInfoModel.h"

@interface PersonalCenterController ()<UITableViewDelegate,UITableViewDataSource,PersonHeaderViewDelegate,FilterHeaderViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)PersonHeaderView *headerView;

@property (nonatomic,strong)KuaiKanInfoModel *kuaiKanModel;

@end

@implementation PersonalCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人中心";

    // 加载页面（界面先行）
    [self configContentView];
    
    // 加载数据
    [self loadDataIfNeed];
}

-(void)configContentView
{
    // 区域
    [self.view addSubview:self.tableView];
    
    // 顶部个人中心区域
    [self.view addSubview:self.headerView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(kHeaderHeight - kHeaderMinShowHeight,0, 0, 0);
    
    if (self.appType == AppApiTypeOfZhuiShu)
    {
        self.headerView.author = self.author;
    }
    
    /*
    // 下拉刷新
    kSelfWeak;
    // 默认查全部
    self.bbsType = -1;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
    }];
     */
}

#pragma mark - 请求数据预处理

-(void)loadDataIfNeed
{
    // 首先判断是否是自己的个人中心
    if ([self.atUserId isEqualToString:[SingletonUser sharedSingletonUser].userInfo.userId])
    {
        self.isMee = YES;
        
        self.headerView.info = [[SingletonUser sharedSingletonUser] userInfo];
        
    }
    else
    {
        self.isMee = NO;
        
        // 查询用户资料
        [self loadUserDataRequest];
    }
    
    if (self.atUserId.length < 1) {
        self.isMee = NO;
    }
    
    // 是否显示设置按钮（默认隐藏）
    self.headerView.btnRight.hidden = YES;
}


#pragma mark - 查询用户数据并加载界面

-(void)loadUserDataRequest
{
    NSString *currentUserId = self.atUserId;

    if (currentUserId.length > 0)
    {
        if (self.appType == AppApiTypeOfKuaiKan)
        {
            ZXRequestTool *request = [[ZXRequestTool alloc] init];
            [request baseRequestWithMethod:[request v2GetMethodWithType:URLTypeOfSix param:@{@"atUserId":currentUserId}] requestType:RequestTypeOfKuaiKan params:nil completion:^(NSDictionary *responseObject) {
                if (SUCCESS)
                {
                    KuaiKanInfoModel *kuaiKanModel = [KuaiKanInfoModel toKuaiKanInfoModel:responseObject[@"data"]];
                    self.kuaiKanModel = kuaiKanModel;
                    self.headerView.kuaiKanModel = kuaiKanModel;
                    
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.appType == AppApiTypeOfKuaiKan)
    {
        Topic *topic = self.kuaiKanModel.topics[indexPath.row];
        topic.order = 0; // 默认倒序排序（即最新章节在最前面)
        BookDetailViewController *bookDetail = [[BookDetailViewController alloc] init];
        bookDetail.book = topic;
        bookDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bookDetail animated:YES];
    }
}

#pragma mark - PersonHeaderViewDelegate

-(void)headerView:(PersonHeaderView *)headerView barItemClick:(BarItemPosition)positin
{
    if (positin == BarItemPositionOfLeft) {
        [self dismissOrPopBack];
    }else{
        [self showText:@"设置界面" inView:self.view];
    }
}

-(void)headerView:(PersonHeaderView *)headerView bottomMenuClick:(BarItemPosition)position
{
    NSInteger showType = position == BarItemPositionOfLeft ? 1 : 2;
    
}

#pragma mark - UITableViewDataSource 和 UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) // 个人简介
    {
        return 1;
    }
    if (self.appType == AppApiTypeOfKuaiKan && self.kuaiKanModel.topics.count > 0)
    {
        return self.kuaiKanModel.topics.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *product = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        product.textLabel.numberOfLines = 0;
        product.textLabel.textColor = [UIColor grayColor];
        product.textLabel.font = [UIFont systemFontOfSize:15];
        NSString *signature = [NSString stringWithFormat:@"简介：这人很懒，什么都没留下!"];
        NSString *sign = [SingletonUser sharedSingletonUser].userInfo.signature;
        if (self.isMee && sign.length > 0) {
            
            signature = sign;
        }
        product.textLabel.text = signature;
        
        return product;
    }
    
    if (self.appType == AppApiTypeOfKuaiKan)
    {
        TopicUserCenterCell *topicCell = [TopicUserCenterCell topicUserCenter:tableView];
        topicCell.topic = self.kuaiKanModel.topics[indexPath.row];
        return topicCell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"我们";
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FilterHeaderView *filterView;
    if (section == 1)  // 全部、精华筛选区域
    {
        filterView = [FilterHeaderView filterHeader:tableView];
        NSArray *titleArr = @[@"TA的作品",@"我的作品"];
        [filterView.headerTitle setText:titleArr[0]];
        if (self.appType == AppApiTypeOfKuaiKan)
        {
            [filterView.headerTitle setText:[NSString stringWithFormat:@"%@(%ld)",titleArr[0],self.kuaiKanModel.topics.count]];
        }
        if (self.isMee) {
            [filterView.headerTitle setText:titleArr[1]];
        }
        filterView.delegate = self;
        [filterView.btnFilter setTitle:titleArr[filterView.currentIndex] forState:UIControlStateNormal];
    }
    return filterView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44.f;
    }
    
    if (self.appType == AppApiTypeOfKuaiKan)
    {
        return 110.f;
    }
    return 0.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40.f;
    }
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 20.f;
    }
    return 0.1f;
}

/**
 *  筛选：全部、精华
 */
-(void)didSelectMenuChange:(NSInteger)index
{
    [self showText:@"筛选" inView:self.view];
}

/**
 *  导航栏处理
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 默认等于：kHeaderHeight - 104.f;
    CGFloat offset = self.tableView.contentOffset.y;
    
    //NSLog(@"个人中心：%lf",offset);
    
    if (offset >= 0)
    {
        if (self.headerView.height == kHeaderHeight - kHeaderMinShowHeight) {
            return;
        }
        [self.headerView configStyleAlpha:1];
        self.headerView.height = kHeaderMinShowHeight;
    }
    else
    {
        self.headerView.height = kHeaderMinShowHeight - offset;
        CGFloat alpha = MIN(1, -offset/(kHeaderHeight - kHeaderMinShowHeight));
        [self.headerView configStyleAlpha:1 - alpha];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 懒加载

-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderMinShowHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kHeaderMinShowHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.25];
        
        _tableView.estimatedRowHeight = 44.f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

-(PersonHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [PersonHeaderView headerVew];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHeaderHeight);
        _headerView.delegate = self;
        _headerView.layer.masksToBounds = YES;
    }
    return _headerView;
}

#pragma mark - 页面生命周期

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

@end
