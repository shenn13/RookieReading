//
//  HotTextBookViewController.m
//  MoreAndMore
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "HotTextBookViewController.h"
#import "ZXShowWaitView.h"

#import "BookTextContentView.h"

#import "RankListModel.h"

@interface HotTextBookViewController ()

@property (nonatomic,weak)ZXShowWaitView *showWaitView;

@property (nonatomic,strong)BookTextContentView *contentView;

@end

@implementation HotTextBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initContentView];
}

#pragma mark （加载UI,开始请求数据）
-(void)initContentView
{
    self.contentView = [[BookTextContentView alloc] initWithFrame:CGRectMake(0, 21, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 21)];
    [self.view addSubview:self.contentView];
    
    self.contentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self rankingListRequest];
    }];
    
    kSelfWeak;
    ZXShowWaitView *showWaitView = [[ZXShowWaitView alloc] initWithOperation:^{
        [weakSelf rankingListRequest];
    }];
    // 插入网络状态showWaitView到self.view的最顶层
    [self.view insertSubview:showWaitView aboveSubview:self.view];
    self.showWaitView = showWaitView;
    
    // 开始加载
    [self.showWaitView showWait];
}

-(void)rankingListRequest
{
    kSelfWeak;
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfOne param:nil] requestType:RequestTypeOfZhuiShu params:nil completion:^(NSDictionary *responseObject) {
        if (SUCCESS_OK)
        {
            [weakSelf.showWaitView removeFromSuperview];
            // 男士的
            weakSelf.contentView.maleRankList = [[RankListModel toRankList:responseObject[@"male"]] mutableCopy];
            
            // 女士的
            weakSelf.contentView.femaleRankList = [[RankListModel toRankList:responseObject[@"female"]] mutableCopy];
            [weakSelf.contentView reloadData];
            
            CGFloat count = MIN(weakSelf.contentView.maleRankList.count, 4);
            
            /**
             *  子栏目榜单列表查询ID
             */
            NSMutableArray *totalAry = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < count; i++)
            {
                RankListModel *model = weakSelf.contentView.maleRankList[i];
                NSString *totalId = model.totalRank.length > 0 ? model.totalRank : model.idd;
                [totalAry addObject:totalId];
            }
            [weakSelf textBookListRequest:totalAry];
        }
        else
        {
            [weakSelf.showWaitView showError];
        }
        if ([weakSelf.contentView.mj_header isRefreshing])
        {
            [weakSelf.contentView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.showWaitView showError];
        if ([weakSelf.contentView.mj_header isRefreshing])
        {
            [weakSelf.contentView.mj_header endRefreshing];
        }
    }];
}

/**
 *  榜单列表数据获取(精选查看：总榜)
 */
-(void)textBookListRequest:(NSArray *)totalRankAry
{
    kSelfWeak;
    for (int i = 0; i < totalRankAry.count; i++)
    {
        NSString *totalId = totalRankAry[i];
        ZXRequestTool *request = [[ZXRequestTool alloc] init];
        [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfTwo param:@{@"totalRankId":totalId}] requestType:RequestTypeOfZhuiShu params:nil completion:^(NSDictionary *responseObject) {
            if (SUCCESS_OK)
            {
                BookTextRanking *ranking = [BookTextRanking toBookTextRanking:responseObject[@"ranking"]];
                if (i== 0)
                {
                    // 先清空原数据
                    [weakSelf.dataSource removeAllObjects];
                    [weakSelf.contentView.dataAry removeAllObjects];
                }
                [weakSelf.dataSource addObject:ranking];
                [weakSelf.contentView.dataAry  addObject:ranking];
                [weakSelf.contentView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 导航栏处理
/*
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.contentView.contentOffset.y > 0)
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

@end
