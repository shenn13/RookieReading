//
//  BookStoreViewController.m
//  MoreAndMore
//
//  Created by Silence on 16/6/5.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookStoreViewController.h"

#import "HotBookViewController.h"
#import "HotTextBookViewController.h"

#import "BookSearchViewController.h"

@interface BookStoreViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic,strong)UISegmentedControl *control;

@property (nonatomic,assign)BOOL isAnimation;

/**
 *  多页控制器
 */
@property (nonatomic,strong)UIPageViewController *pageVC;
/**
 *  存放的子页面
 */
@property (nonatomic,strong)NSMutableArray<UIViewController *> *subControllers;

@property (nonatomic,strong)CALayer *topLayer;

@end

@implementation BookStoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initWithContentView];
    
    // 获取已登录个人信息
    [SingletonUser getUserFromLocaFile];
    // 如果为空：则表示未登录
    SingletonUser *user = [SingletonUser sharedSingletonUser];
    if (user.sessionKey.length < 1)
    {
        LOGINNEED_ACTION;
    }
}

-(void)initWithContentView
{
    // 默认展示热门(分页控制器)
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    
    // 顶部装天栏遮罩
    [self.view.layer addSublayer:self.topLayer];
    
    // 导航栏菜单
    self.navigationItem.titleView = self.control;
    
    // 搜索按钮
    [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[@"search_Nav"] selArr:nil];
    
    kSelfWeak;
    [[NSNotificationCenter defaultCenter] addObserverForName:CHANGE_JINGXUAN_MENU object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * note) {
        // 切换选项卡
        [weakSelf.navigationController popViewControllerAnimated:YES];
        weakSelf.control.selectedSegmentIndex = [note.userInfo[@"menu_jingxuan"] integerValue];
        [weakSelf segmentControlAction:weakSelf.control];
    }];
}

#pragma mark 导航栏右边按钮点击事件
-(void)rightBarItemClick:(UIButton *)rightItem
{
    BookSearchViewController *bookSearch = [[BookSearchViewController alloc] init];
    bookSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookSearch animated:NO];
}

#pragma mark 页面切换(热门、类型)
-(void)segmentControlAction:(UISegmentedControl *)control
{
    if (self.isAnimation) {
        control.selectedSegmentIndex = 1 - control.selectedSegmentIndex;
        return;
    }
    
    self.isAnimation = YES;
    /*
    UIPageViewControllerNavigationDirectionForward  // 前翻
    UIPageViewControllerNavigationDirectionReverse  // 后翻
     */
    UIPageViewControllerNavigationDirection direction = control.selectedSegmentIndex == 1 ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse  ;
    
    if (self.control.selectedSegmentIndex < self.subControllers.count)
    {
        kSelfWeak;
        [self.pageVC setViewControllers:@[self.subControllers[self.control.selectedSegmentIndex]] direction:direction animated:NO completion:^(BOOL finished) {
            weakSelf.isAnimation = NO;
        }];
    }
}

#pragma mark 根据数组元素，得到下标值
- (NSUInteger)indexOfViewController:(UIViewController *)viewControlller
{
    return [self.subControllers indexOfObject:viewControlller];
}

#pragma mark - UIPageViewControllerDataSource

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [self.subControllers count]) {
        return nil;
    }
    
    return self.subControllers[index];
}

// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    
    return self.subControllers[index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0)
{
    NSLog(@"开始翻页调用");
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSInteger index = [self indexOfViewController:self.pageVC.viewControllers.firstObject];
    self.control.selectedSegmentIndex = index;
    NSLog(@"翻页完成调用");
}

- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED
{
    return UIInterfaceOrientationPortrait;
}


-(UISegmentedControl *)control
{
    if (!_control)
    {
        _control = [[UISegmentedControl alloc] initWithItems:@[@"文字",@"图书"]];
        _control.frame = CGRectMake(0, 0, 140, 30);
        _control.selectedSegmentIndex = 0;
        _control.tintColor = [UIColor whiteColor];
        // 文本颜色
        [_control setTitleTextAttributes:@{NSFontAttributeName:FONT(15),NSForegroundColorAttributeName:THEME_TINTCOLOR} forState:UIControlStateNormal];
        [_control setTitleTextAttributes:@{NSFontAttributeName:FONT(16),NSForegroundColorAttributeName:THEME_COLOR} forState:UIControlStateSelected];
    
        [_control addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}

-(NSMutableArray *)subControllers
{
    if (!_subControllers) {
        _subControllers = [NSMutableArray arrayWithCapacity:0];
        // 配置子控制器
        HotBookViewController *hot = [[HotBookViewController alloc] init];
        HotTextBookViewController *hotText = [[HotTextBookViewController alloc] init];
        // 热门电子书
        [_subControllers addObject:hotText];
        // 热门图书
        [_subControllers addObject:hot];
    }
    return _subControllers;
}

-(UIPageViewController *)pageVC
{
    if (!_pageVC) {
        /*
         UIPageViewControllerSpineLocationNone = 0, // 默认
         UIPageViewControllerSpineLocationMin = 1,  // 书棱在左边
         UIPageViewControllerSpineLocationMid = 2,  // 书棱在中间，同时显示两页
         UIPageViewControllerSpineLocationMax = 3   // 书棱在右边
         */
        // 如果要同时显示两页，options参数要设置为UIPageViewControllerSpineLocationMid
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationNone] forKey:UIPageViewControllerOptionSpineLocationKey];
        
        /*
         UIPageViewControllerNavigationOrientationHorizontal = 0, 水平翻页
         UIPageViewControllerNavigationOrientationVertical = 1    垂直翻页
         UIPageViewControllerTransitionStylePageCurl = 0          书本效果
         UIPageViewControllerTransitionStyleScroll = 1            Scroll效果
         */
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        
        // 定义“这本书”的尺寸
        _pageVC.view.frame = self.view.bounds;

        [_pageVC setViewControllers:@[self.subControllers[1]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    return _pageVC;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.topLayer.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.topLayer.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark 顶部状态栏遮罩
-(CALayer *)topLayer
{
    if (!_topLayer) {
        _topLayer = [CALayer layer];
        _topLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 21);
        _topLayer.backgroundColor = THEME_COLOR.CGColor;
    }
    return _topLayer;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
