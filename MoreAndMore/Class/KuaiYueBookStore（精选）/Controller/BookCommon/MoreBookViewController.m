//
//  MoreBookViewController.m
//  MoreAndMore
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "MoreBookViewController.h"

#import "MoreTopicCell.h"
#import "BookTextMoreCell.h"

#import "BookDetailViewController.h"
#import "BookTextDetailController.h"

@interface MoreBookViewController ()<MoreTopicCellDelegate,BookTextMoreCellDelegate>

@property (nonatomic,assign)NSInteger currentPage;

@end

@implementation MoreBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self configNotification];

    if (self.type == RequestTypeOfKuaiKan)
    {
        [self initRefreshContent];
    }
}

-(void)setRanking:(BookTextRanking *)ranking
{
    _ranking = ranking;
    
    for (TextBook *book in ranking.books)
    {
        [book checkItCollected];
    }
}

#pragma mark - 刷新控件相关

-(void)initRefreshContent
{
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

#pragma mark - 注册通知相关

-(void)configNotification
{
    kSelfWeak;
    
    if (self.type == RequestTypeOfKuaiKan)
    {
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
    else
    {
        // 书籍列表刷新事件（文字）
        [[NSNotificationCenter defaultCenter] addObserverForName:TEXT_BOOK_REFRESH object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * note) {
            NSString *IDD = note.userInfo[TEXT_BOOK_ID];
            for (TextBook *textBook in weakSelf.ranking.books)
            {
                if ([textBook.idd isEqualToString:IDD])
                {
                    NSInteger index = [weakSelf.ranking.books indexOfObject:textBook];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }];

    }
}

#pragma mark - 数据请求

-(void)initWithRequest:(MJRefreshComponent *)refreshView
{
    if (self.method.length < 1) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    kSelfWeak;
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    [request baseRequestWithMethod:self.method requestType:RequestTypeOfKuaiKan params:@{@"limit":PAGESIZE20,@"offset":@(self.currentPage)} completion:^(NSDictionary *responseObject) {
        if (SUCCESS)
        {
            NSMutableArray *dataAry = [[Topic toTopicsArr:responseObject[@"data"][@"topics"]] mutableCopy];
            if (dataAry.count > 0)
            {
                if ([refreshView isKindOfClass:[MJRefreshNormalHeader class]])
                {
                    [weakSelf.dataSource removeAllObjects];
                    weakSelf.currentPage = dataAry.count;
                }
                if ([refreshView isKindOfClass:[MJRefreshBackNormalFooter class]])
                {
                    weakSelf.currentPage += dataAry.count;
                }
                
                [weakSelf.dataSource addObjectsFromArray:dataAry];
                [weakSelf.tableView reloadData];
            }
            else
            {
                [weakSelf showTextWithState:ActivityHUDStateFailed inView:WINDOW text:@"没有更多数据了!"];
            }
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == RequestTypeOfZhuiShu)
    {
        return self.ranking.books.count;
    }
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == RequestTypeOfZhuiShu)
    {
        BookTextMoreCell *textMore = [BookTextMoreCell textMoreCell:tableView];
        textMore.indexPath = indexPath;
        textMore.textBook = self.ranking.books[indexPath.row];
        textMore.delegate = self;
        return textMore;
    }
    
    MoreTopicCell *topicCell = [MoreTopicCell moreTopicCell:tableView];
    topicCell.indexPath = indexPath;
    topicCell.delegate = self;
    topicCell.topic = self.dataSource[indexPath.row];
    return topicCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == RequestTypeOfZhuiShu)
    {
        return 120.f;
    }
    return 90.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == RequestTypeOfZhuiShu)
    {
        BookTextDetailController *textDetail = [[BookTextDetailController alloc] initWithStyle:UITableViewStyleGrouped];
        textDetail.textBook = self.ranking.books[indexPath.row];
        textDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:textDetail animated:YES];
        return;
    }
    
    Topic *topic = self.dataSource[indexPath.row];
    topic.order = 0; // 默认倒序排序（即最新章节在最前面)
    BookDetailViewController *bookDetail = [[BookDetailViewController alloc] init];
    bookDetail.book = topic;
    bookDetail.hidesBottomBarWhenPushed = YES;
    [JUMP_MANAGER.jumpNavigation pushViewController:bookDetail animated:YES];
}

#pragma mark - 收藏或取消收藏(文字)
-(void)moreTextBook:(BookTextMoreCell *)moreCell didClickCollect:(TextBook *)textBook
{
    kSelfWeak;
    
    __block TextBook *myBook = self.ranking.books[moreCell.indexPath.row];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
