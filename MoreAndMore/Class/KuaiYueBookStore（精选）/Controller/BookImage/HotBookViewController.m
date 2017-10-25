//
//  HotBookViewController.m
//  MoreAndMore
//
//  Created by Silence on 16/7/15.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "HotBookViewController.h"
#import "AdvertModel.h"
#import "StoreListModel.h"

#import "BookStoreListView.h"

@interface HotBookViewController ()

@property (nonatomic,weak)ZXShowWaitView *showWaitView;

@property (nonatomic,weak)BookStoreListView *contentList;

@end

@implementation HotBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 默认使用V2的接口
    _isFromV2List = YES;
    
    /**
     *  精选漫画列表界面
     */
    [self settingBackGround];
    
    [self initWithContentView];
    
    __weak typeof(self) weakSelf = self;
    self.contentList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isFromV2List) {
            // 漫画V2版本数据请求
            [weakSelf initWithDataRequestV2];
        }else{
            // 漫画V1版本数据请求
            [weakSelf initWithDataRequest];
        }
    }];
}

- (void)settingBackGround
{
    // 图书内容区域
    BookStoreListView *contentList = [[BookStoreListView alloc] initWithFrame:CGRectMake(0, 21, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 21)];
    [self.view addSubview:contentList];
    self.contentList = contentList;
    
}

#pragma mark - 切换主页数据来源 V1 V2版本

-(void)loadDataFromV2:(BOOL)isFromV2
{
    _isFromV2List = isFromV2;
    
    if ([self.contentList.mj_header isRefreshing]) {
        return;
    }
    
    [self.contentList.mj_header beginRefreshing];
}

#pragma mark （加载UI,开始请求数据）
-(void)initWithContentView
{
    kSelfWeak;
    ZXShowWaitView *showWaitView = [[ZXShowWaitView alloc] initWithOperation:^{
        if (_isFromV2List) {
            // 漫画V2版本数据请求
            [weakSelf initWithDataRequestV2];
        }else{
            // 漫画V1版本数据请求
            [weakSelf initWithDataRequest];
        }
    }];
    // 插入网络状态showWaitView到self.view的最顶层
    [self.view insertSubview:showWaitView aboveSubview:self.view];
    self.showWaitView = showWaitView;
    
    // 开始加载
    [self.showWaitView showWait];
}

/**
 *  V2漫画主页新接口
 */
-(void)initWithDataRequestV2
{
    self.contentList.isFromV2 = YES;
    
    ZXRequestTool *request = [ZXRequestTool new];
    [request baseRequestWithMethod:[request v2GetMethodWithType:URLTypeOfOne param:nil] requestType:RequestTypeOfKuaiKan params:@{} completion:^(NSDictionary *responseObject) {
        if (SUCCESS) {
            [self.showWaitView removeFromSuperview];
            // V2版本
            NSArray *dataArr = [StoreListModel toStoreListModel:responseObject[@"data"][@"infos"]];
            // 广告栏数据
            StoreListModel *advert = [dataArr objectAtIndex:0];
            if (advert.banners.count > 0) {
                self.contentList.advertArray = [AdvertModel handleImageUrlIfNeed:advert.banners];
            }
            // 内容区域
            NSMutableArray *newListArr = [NSMutableArray arrayWithCapacity:0];
            // 三个特殊
            NSArray *titleArr = @[@"主编力推",@"少女纯爱",@"轻松爆笑"];
            for (StoreListModel *listModel in dataArr)
            {
                if (listModel == advert) continue;
                // 特殊处理
                for (NSString *title in titleArr)
                {
                    if (listModel.item_type == 4 && [listModel.title isEqualToString:title])
                    {
                        listModel.item_type = 7;
                    }
                }
                if ([listModel.title isEqualToString:@"绝美古风"])
                {
                    listModel.item_type = 5;
                }
                [newListArr addObject:listModel];
            }
            self.contentList.listArr = [StoreListModel handleImageUrlIfNeed:newListArr];
            
            [self.contentList reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
            if ([self.contentList.mj_header isRefreshing])
            {
                [self.contentList.mj_header endRefreshing];
            }
        }else{
            [self.showWaitView showError];
        }
    } failure:^(NSError *error) {
        [self.showWaitView showError];
        if ([self.contentList.mj_header isRefreshing])
        {
            [self.contentList.mj_header endRefreshing];
        }
    }];

}

#pragma mark 顶部广告栏数据请求
-(void)initWithDataRequest
{
    self.contentList.isFromV2 = NO;
    
    ZXRequestTool *request = [ZXRequestTool new];
    [request baseRequestWithMethod:[request getMethodWithType:URLTypeOfOne param:nil] requestType:RequestTypeOfKuaiKan params:@{} completion:^(NSDictionary *responseObject) {
        if (SUCCESS) {
            [self.showWaitView removeFromSuperview];
            
            NSArray *dataArr = [AdvertModel advertArrWithDataArr:responseObject[@"data"][@"banner_group"]];
            
            NSLog(@"广告数据:%@",dataArr);
            
            self.contentList.advertArray = dataArr;
            [self.contentList reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
            [self homeDataRequest];
        }else{
            [self.showWaitView showError];
        }
    } failure:^(NSError *error) {
        [self.showWaitView showError];
    }];
}

#pragma mark 漫画数据加载
-(void)homeDataRequest
{
    ZXRequestTool *request = [ZXRequestTool new];
    // 更多列表数据
    [request baseRequestWithMethod:[request getMethodWithType:URLTypeOfTwo param:nil] requestType:RequestTypeOfKuaiKan params:nil completion:^(NSDictionary *responseObject) {
        
        NSArray *dataArr = [StoreListModel toStoreListModel:responseObject[@"data"][@"infos"]];
        
        NSLog(@"主页数据:%@",dataArr);

        NSArray *typeArr = @[@(7),@(2),@(9),@(4),@(6)];
        // 依据label_id从小到大排序
        NSArray *theTopics;
        for (int i = 0; i < dataArr.count; i++)
        {
            StoreListModel *storeModel = dataArr[i];
            
            theTopics = [storeModel.topics sortedArrayUsingComparator:^NSComparisonResult(Topic *obj1, Topic *obj2) {
                if (obj1.label_id > obj2.label_id)
                {
                    return NSOrderedDescending;
                }
                else
                {
                    return NSOrderedAscending;
                }
            }];

            storeModel.topics = [theTopics mutableCopy];
            
            NSInteger index = i%typeArr.count;
            storeModel.item_type = [typeArr[index] integerValue];
        }
        
        self.contentList.listArr = dataArr;
        [self.contentList reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
    } failure:^(NSError *error) {
    }];
}

-(void)rightBarItemClick:(UIButton *)rightItem
{
    rightItem.selected = !rightItem.selected;
    
}

#pragma mark - 导航栏处理
/*
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    if (self.contentList.contentOffset.y > 0)
    {
        self.navigationController.navigationBarHidden = YES;
    }
  
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
