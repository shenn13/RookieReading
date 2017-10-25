//
//  CBReaderPageController.m
//  MoreAndMore
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "CBReaderPageController.h"
#import "CBReaderController.h"

#import "UIViewController+TopShareView.h"

#import "CBMenuPanel.h"
#import "CBChalpterList.h"

#import "CBReaderStyle.h"
#import "CBPaging.h"

typedef NS_ENUM(NSInteger,ReadPageChangeType) {
    ReadPageChangeTypeOfOther = 0,          // 不需要动画
    ReadPageChangeTypeOfNextChalpter = 1,   // 进入下一章节第一页
    ReadPageChangeTypeOfLastChalpter        // 返回上一章节最后一节
};

@interface CBReaderPageController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic,strong)UIPageViewController *pageController;

@property (nonatomic,strong)NSMutableArray *pages;
@property (nonatomic,strong)CBPaging *paging;
@property (nonatomic,assign)ReadPageChangeType pageType;

@property (nonatomic,strong)CBMenuPanel *menuPanel;
@property (nonatomic,strong)CBChalpterList *listView;

@end

@implementation CBReaderPageController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadContentViews];
    
    [self loadBookSource];
}

-(void)loadContentViews
{
    // 阅读器风格
    CBReaderStyle *style = [CBReaderStyle shareStyle];
    self.view.backgroundColor = style.backColor;
    // 页面控制器
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    // 设置面板
    CBMenuPanel *menuPanel = [[CBMenuPanel alloc] init];
    [self.view addSubview:menuPanel];
    self.menuPanel = menuPanel;
    // 目录面板
    CBChalpterList *listView = [[CBChalpterList alloc] init];
    [self.view addSubview:listView];
    self.listView = listView;
}

-(void)loadBookSource
{
    kSelfWeak;
    self.menuPanel.CBMenuPanleAction = ^(CBMenuPanelActionType actionType){
        if (actionType == CBMenuPanelActionTypeClose){
            // 返回
            [weakSelf dismissOrPopBack];
        }
        else if (actionType == CBMenuPanelActionTypeMore){
            // 分享及其他
            [weakSelf showShareViewWithAppInfo];
        }
        else if (actionType == CBMenuPanelActionTypeLast){
            // 上一章
            weakSelf.pageType = ReadPageChangeTypeOfOther;
            [weakSelf.listView loadChalpterDetailWithNewChalpter:weakSelf.listView.chalpterIndex - 1];
        }
        else if (actionType == CBMenuPanelActionTypeNext){
            // 下一章
            weakSelf.pageType = ReadPageChangeTypeOfOther;
            [weakSelf.listView loadChalpterDetailWithNewChalpter:weakSelf.listView.chalpterIndex + 1];
        }
        else if (actionType == CBMenuPanelActionTypePageJump){
            // 进度条跳转章节
            weakSelf.pageType = ReadPageChangeTypeOfOther;
            [weakSelf.listView loadChalpterDetailWithNewChalpter:weakSelf.menuPanel.jumpChalpterIndex];
        }
        else if (actionType == CBMenuPanelActionTypeBgChange){
            // 主题色切换
            [weakSelf changeReaderStyleIfNeed];
        }
        else if (actionType == CBMenuPanelActionTypeFontChange){
            // 字体大小切换
            [weakSelf.paging setChapter:weakSelf.paging.chapter];
            [weakSelf reloadPagingChalpter];
        }
        else if (actionType == CBMenuPanelActionTypeExtLeftMenu){
            // 章节目录
            weakSelf.listView.listType = ChalpterListTypeChalpter;
            [weakSelf.listView showChalpterListView:YES];
        }
        else if (actionType == CBMenuPanelActionTypeExtRightMenu){
            // 书籍源
            weakSelf.listView.listType = ChalpterListTypeSource;
            [weakSelf.listView showChalpterListView:YES];
        }
    };
    
    self.listView.ChalpterLoadCompletion = ^(ChalpterDetailModel *chalpterModel){
        // 初始化章节
        weakSelf.paging = [[CBPaging alloc] initWithChalpter:chalpterModel];
        [weakSelf reloadPagingChalpter];
        // 更新相关阅读进度/UI
        NSInteger readerCount = weakSelf.listView.chalpterList.chapters.count;
        NSInteger readerIndex = weakSelf.listView.chalpterIndex;
        [weakSelf.menuPanel updateReaderPanelWithChalpters:readerCount-1 readerChalpter:readerIndex];
        // 第几章
        NSLog(@"《%@》 章节有 <%ld> 页",chalpterModel.title,weakSelf.paging.pageCount);
    };
    
    // 加载数据<书籍源、书籍章节目录>
    [self.listView loadDataWithBookID:self.textBookId];
}

#pragma mark - 初始化章节模型

-(void)reloadPagingChalpter
{
    self.pages = [NSMutableArray arrayWithCapacity:0];
    // 索引从<0>开始
    ChalpterDetailModel *chalpterModel = self.paging.chapter;
    for (int i = 0; i < [self.paging pageCount]; i++)
    {
        NSString *content = [self.paging stringOfPage:i];
        CBReaderController *reader = [self readerViewControllerWithText:content chalpterTitle:chalpterModel.title];
        [self.pages addObject:reader];
    }
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
    // 如果是返回上一章
    if (self.pageType == ReadPageChangeTypeOfLastChalpter) {
        self.paging.readerPage = [self.paging pageCount] - 1;
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    [self.pageController setViewControllers:@[self.pages[self.paging.readerPage]] direction:direction animated:self.pageType completion:nil];
    // 复原
    self.pageType = ReadPageChangeTypeOfOther;
}

#pragma mark - 初始化阅读页

-(CBReaderController *)readerViewControllerWithText:(NSString *)textContent chalpterTitle:(NSString *)title
{
    CBReaderController *reader = [[CBReaderController alloc] init];
    CBReaderStyle *style = [CBReaderStyle shareStyle];
    reader.view.backgroundColor = style.backColor;
    reader.readerView.text = textContent;
    reader.infoTool.chalpterTitle = title;
    __weak typeof(self) weakSelf = self;
    reader.readerView.ReaderViewTapAction = ^(){
        [weakSelf.menuPanel showPanelMenu:YES];
    };
    return reader;
}

#pragma mark - 背景风格修改
-(void)changeReaderStyleIfNeed
{
    CBReaderStyle *style = [CBReaderStyle shareStyle];
    self.view.backgroundColor = style.backColor;
    for (CBReaderController *reader in self.pages)
    {
        reader.view.backgroundColor = style.backColor;
    }
}

#pragma mark - UIPageViewControllerDataSource && UIPageViewControllerDelegate

// 返回下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.pages indexOfObject:viewController];
    index += 1;
    if (index >= self.pages.count || index == NSNotFound)
    {
        // 进入下一章节
        if (index >= self.pages.count)
        {
            self.pageType = ReadPageChangeTypeOfNextChalpter;
            [self.listView loadChalpterDetailWithNewChalpter:self.listView.chalpterIndex + 1];
        }
        return nil;
    }
    return [self.pages objectAtIndex:index];
}

// 返回上一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.pages indexOfObject:viewController];
    index -= 1;
    if (index < 0 || index == NSNotFound)
    {
        // 进入上一章节
        if (index >= self.pages.count)
        {
            self.pageType = ReadPageChangeTypeOfLastChalpter;
            [self.listView loadChalpterDetailWithNewChalpter:self.listView.chalpterIndex - 1];
        }
        return nil;
    }
    return [self.pages objectAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0)
{
    NSLog(@"开始翻页调用");
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSLog(@"翻页完成调用");
    UIViewController *showVC = self.pageController.viewControllers.firstObject;
    self.paging.readerPage = [self.pages indexOfObject:showVC];
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

#pragma mark - 懒加载
-(UIPageViewController *)pageController{
    if (_pageController == nil) {
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationNone] forKey:UIPageViewControllerOptionSpineLocationKey];
        CBReaderStyle *style = [CBReaderStyle shareStyle];
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:style.transitionType navigationOrientation:style.orientation options:options];
        _pageController.view.bounds = self.view.bounds;
        _pageController.delegate = self;
        _pageController.dataSource = self;
    }
    return _pageController;
}

- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - 页面生命周期

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
