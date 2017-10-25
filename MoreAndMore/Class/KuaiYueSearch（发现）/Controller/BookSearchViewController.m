//
//  BookSearchViewController.m
//  MoreAndMore
//
//  Created by apple on 16/10/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookSearchViewController.h"

#import "BookTextDetailController.h"
#import "BookDetailViewController.h"

#import "MoreTopicCell.h"
#import "BookTextMoreCell.h"

#import "SGTopScrollMenu.h"

@interface BookSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SGTopScrollMenuDelegate,MoreTopicCellDelegate,BookTextMoreCellDelegate>

@property (nonatomic,strong)NSMutableArray *searchDataSource;

/**
 *  控件
 */
@property (nonatomic,weak)SGTopScrollMenu *topMenu;

@property (nonatomic,strong)UISearchBar *searchBar;

@property (nonatomic,strong)UITableView *tableView;

/**
 *  参数
 */
@property (nonatomic,assign)NSInteger offset; // 漫画
@property (nonatomic,assign)NSInteger start; // 小说

@property (nonatomic,assign)NSInteger menuIndex;

@end

@implementation BookSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.menuIndex = 0;
    self.offset = 0;
    self.start = 0;
    
    // 通知相关
    [self configNotification];
    
    // 内容区域
    [self initWithContentView];
}

#pragma mark - 注册通知相关

-(void)configNotification
{
    kSelfWeak;
    
    if (self.menuIndex == 0)
    {
        // 书籍列表刷新事件(图书)
        [[NSNotificationCenter defaultCenter] addObserverForName:IMAGE_BOOK_REFRESH object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * note) {
            NSString *IDD = note.userInfo[IMAGE_BOOK_ID];
            for (Topic *topic in weakSelf.searchDataSource[weakSelf.menuIndex])
            {
                if ([topic.idd isEqualToString:IDD])
                {
                    NSInteger index = [weakSelf.searchDataSource[weakSelf.menuIndex] indexOfObject:topic];
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
            for (TextBook *textBook in  weakSelf.searchDataSource[weakSelf.menuIndex])
            {
                if ([textBook.idd isEqualToString:IDD])
                {
                    NSInteger index = [weakSelf.searchDataSource[weakSelf.menuIndex] indexOfObject:textBook];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }];
        
    }
}

-(void)setMenuIndex:(NSInteger)menuIndex
{
    _menuIndex = menuIndex;
    
    // 有搜索关键字
    if (self.searchBar.text.length > 0)
    {
        if (self.menuIndex == 0) {
            self.offset = 0;
        }else{
            self.start= 0;
        }
        [self bookSearchWithKeyWord:self.searchBar.text refreshView:nil];
    }
    else
    {
        [self.tableView reloadData];
    }
}

-(void)initWithContentView
{
    // 搜索框
    self.navigationItem.titleView = self.searchBar;
    
    CGFloat menuHei = 40;
    // 顶部筛选菜单
    SGTopScrollMenu *topMenu = [SGTopScrollMenu topScrollMenuWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, menuHei)];
    topMenu.backgroundColor = [UIColor whiteColor];
    topMenu.titlesArr = @[@"图书",@"文字"];
    topMenu.topScrollMenuDelegate = self;
    [self.view addSubview:topMenu];
    self.topMenu = topMenu;
    
    // 表格
    [self.view addSubview:self.tableView];
    
    kSelfWeak;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.menuIndex == 0) {
            weakSelf.offset = 0;
        }else{
            weakSelf.start= 0;
        }
        [weakSelf bookSearchWithKeyWord:weakSelf.searchBar.text refreshView:weakSelf.tableView.mj_header];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf bookSearchWithKeyWord:weakSelf.searchBar.text refreshView:weakSelf.tableView.mj_footer];
    }];
}

// 书籍搜索
-(void)bookSearchWithKeyWord:(NSString *)keyWord refreshView:(MJRefreshComponent *)refreshView;
{
    if (keyWord.length < 1)
    {
        [self showText:@"请输入搜索关键词" inView:self.view];
        [self.searchBar becomeFirstResponder];
        [refreshView endRefreshing];
        return;
    }
    if (refreshView == nil)
    {
        [self startActivityWithText:REQUESTTIPING];
    }
    
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSString *method;
    RequestType requestType = RequestTypeOfKuaiKan;
    if (self.menuIndex == 0)
    {
        // 漫画搜索
        method = [request v2GetMethodWithType:URLTypeOfEight param:nil];
        requestType = RequestTypeOfKuaiKan;
        
        [param setObject:keyWord forKey:@"keyword"];
        [param setObject:@(self.offset) forKey:@"offset"];
    }
    else if (self.menuIndex == 1)
    {
        // 小说搜索
        method  = [request getTextMethodWithType:URLTypeOfFourteen param:nil];
        requestType = RequestTypeOfZhuiShu;

        [param setObject:keyWord forKey:@"query"];
        [param setObject:@(self.start) forKey:@"start"];
    }
    [param setObject:PAGESIZE20 forKey:@"limit"];

    kSelfWeak;
    [request baseRequestWithMethod:method requestType:requestType params:param completion:^(NSDictionary *responseObject) {
        ActivityHUDState state = ActivityHUDStateFailed;
        NSString *resultMes = REQUESTTIPFAI;
        if (SUCCESS || SUCCESS_OK)
        {
            state = ActivityHUDStateSuccess;
            resultMes = REQUESTTIPSUC;
            
            NSMutableArray *newAry = nil;
            if (weakSelf.menuIndex == 0)
            {
                newAry = [[Topic toTopicsArr:responseObject[@"data"][@"topics"]] mutableCopy];
            }
            else
            {
                newAry = [[TextBook toTextBookAry:responseObject[@"books"]] mutableCopy];
                for (TextBook *textBook in newAry)
                {
                    [textBook checkItCollected];
                }
            }
            
            if (newAry.count > 0)
            {
                NSMutableArray *currentAry = weakSelf.searchDataSource[weakSelf.menuIndex];
                // 是刷新就清空原数据
                if ((weakSelf.menuIndex == 0 && weakSelf.offset == 0) || (weakSelf.menuIndex == 1 && weakSelf.start == 0))
                {
                    [currentAry removeAllObjects];
                }
                // 当前页更新
                if (weakSelf.menuIndex == 0) {
                    weakSelf.offset += newAry.count;
                }else{
                    weakSelf.start += newAry.count;
                }

                [currentAry addObjectsFromArray:newAry];
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

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.tableView.mj_header beginRefreshing];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否放弃本次搜索!" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert showWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self dismissOrPopBack];
            }
        }];
    }
    else
    {
        [self dismissOrPopBack];
    }
}

#pragma mark - SGTopScrollMenuDelegate

-(void)SGTopScrollMenu:(SGTopScrollMenu *)topScrollMenu didSelectTitleAtIndex:(NSInteger)index
{
    [self.searchBar resignFirstResponder];
    
    if (index != self.menuIndex && index < 2)
    {
        self.menuIndex = index;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchDataSource[self.menuIndex] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataAry = self.searchDataSource[self.menuIndex];
    
    if (self.menuIndex == 0)
    {
        MoreTopicCell *topicCell = [MoreTopicCell moreTopicCell:tableView];
        topicCell.indexPath = indexPath;
        if (dataAry.count > indexPath.row) {
            topicCell.topic = dataAry[indexPath.row];
        }
        topicCell.delegate = self;
        return topicCell;
    }
    else
    {
        BookTextMoreCell *textMore = [BookTextMoreCell textMoreCell:tableView];
        textMore.indexPath = indexPath;
        if (dataAry.count > indexPath.row) {
            textMore.textBook = dataAry[indexPath.row];
        }
        textMore.delegate = self;
        return textMore;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *dataAry = self.searchDataSource[self.menuIndex];
    
    if (self.menuIndex == 1)
    {
        BookTextDetailController *textDetail = [[BookTextDetailController alloc] initWithStyle:UITableViewStyleGrouped];
        if (dataAry.count > indexPath.row) {
            textDetail.textBook = dataAry[indexPath.row];
        }
        textDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:textDetail animated:YES];
        return;
    }
    
    Topic *topic;
    if (dataAry.count > indexPath.row) {
        topic = dataAry[indexPath.row];
    }
    topic.order = 0; // 默认倒序排序（即最新章节在最前面)
    BookDetailViewController *bookDetail = [[BookDetailViewController alloc] init];
    bookDetail.book = topic;
    bookDetail.hidesBottomBarWhenPushed = YES;
    [JUMP_MANAGER.jumpNavigation pushViewController:bookDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.menuIndex == 0)
    {
        return 90.f;
    }
    return 120.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - 收藏或取消收藏(文字)

-(void)moreTextBook:(BookTextMoreCell *)moreCell didClickCollect:(TextBook *)textBook
{
    kSelfWeak;
    
    __block TextBook *myBook = self.searchDataSource[self.menuIndex][moreCell.indexPath.row];
    if (!myBook) return;
    
    [myBook textBookCollectBookComplete:^(BOOL isSuccess) {
        if (isSuccess) {
            myBook.isCollect = !textBook.isCollect;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[moreCell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            NSString *message = myBook.isCollect ? @"收藏成功!" : @"取消收藏成功!";
            [weakSelf showText:message inView:weakSelf.view];
        }
    }];
}

#pragma mark - 收藏或取消收藏(图书)

-(void)moreTopic:(MoreTopicCell *)moreCell didClickCollect:(Topic *)topic
{
    kSelfWeak;
    
    __block Topic *data_topic = self.searchDataSource[self.menuIndex][moreCell.indexPath.row];
    
    if (!data_topic) return;
    
    [data_topic topicCollectBookComplete:^(BOOL isSuccess) {
        if (isSuccess) {
            data_topic.is_favourite = !data_topic.is_favourite;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[moreCell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            NSString *message = data_topic.is_favourite ? @"收藏成功!" : @"取消收藏成功!";
            [weakSelf showText:message inView:weakSelf.view];
        }
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.searchDataSource[self.menuIndex] count] < 1)
    {
        [self.searchBar becomeFirstResponder];
    }
}

#pragma mark - 懒加载

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}


-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 44)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入书名/作者名搜索";
        _searchBar.showsCancelButton = YES;
        for (UIView *view in _searchBar.subviews[0].subviews)
        {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *cancelBtn = (UIButton *)view;
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            }
            if ([view isKindOfClass:[UITextField class]])
            {
                UITextField *textField = (UITextField *)view;
                textField.textColor = [UIColor whiteColor];                         //修改输入字体的颜色
                [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];   //修改placeholder的颜色
            }
        }
    }
    return _searchBar;
}

-(NSMutableArray *)searchDataSource
{
    if (!_searchDataSource) {
        _searchDataSource = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *newAryImage = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *newAryText = [NSMutableArray arrayWithCapacity:0];
        [_searchDataSource addObject:newAryImage];
        [_searchDataSource addObject:newAryText];
    }
    return _searchDataSource;
}

@end
