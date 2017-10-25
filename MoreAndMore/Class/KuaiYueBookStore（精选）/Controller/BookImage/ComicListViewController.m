//
//  ComicListViewController.m
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ComicListViewController.h"
#import "BookDetail.h"

@interface ComicListViewController ()

@property (nonatomic,strong)BookDetail *detail;

@property (nonatomic,assign)NSInteger selIndex;

/**
 *  0 降序    1升序
 */
@property (nonatomic,assign)NSInteger sort;

@end

@implementation ComicListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"章节列表";
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = LINE_COLOR;
    self.tableView.rowHeight = 50.f;
    
    kSelfWeak;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf bookDetailRequest];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
    
    [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[@"tips_menu_desc"] selArr:nil];
}

#pragma mark - 导航栏右边按钮点击事件

-(void)rightBarItemClick:(UIButton *)rightItem
{
    if (!self.detail) return;
    
    rightItem.selected = NO;
    
    self.sort = !self.sort;
}

/**
 *  降序、升序
 */

-(void)setSort:(NSInteger)sort
{
    _sort = sort;

    NSString *itemTitle = sort ? @"tips_menu_aesc" : @"tips_menu_desc";
    
    [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[itemTitle] selArr:nil];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:sort];
    //其中，updated_at为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [self.detail.comics sortUsingDescriptors:sortDescriptors];
    [self.tableView reloadData];
    
    self.selIndex = self.detail.comics.count - self.selIndex - 1;
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self showTextWithState:ActivityHUDStateSuccess inView:WINDOW text:@"排序成功！"];
    
}

#pragma mark - 书籍章节列表查询

-(void)bookDetailRequest
{
    ZXRequestTool *request = [ZXRequestTool new];
    
    NSDictionary *param = @{@"bookId":self.bookId};
    
    if (param.count < 1) return;
    
    kSelfWeak;
    [request baseRequestWithMethod:[request getMethodWithType:URLTypeOfThree param:param] requestType:RequestTypeOfKuaiKan params:@{@"sort":@(self.sort)} completion:^(NSDictionary *responseObject) {
        if (SUCCESS) {
            BookDetail *detail = [BookDetail toBookDetailModel:responseObject[@"data"]];
            if (detail) {
                weakSelf.detail = detail;
                
                for (BookComic *comic in detail.comics)
                {
                    if ([weakSelf.comicId isEqualToString:comic.idd])
                    {
                        // 当前应该选中哪一章
                        weakSelf.selIndex = [detail.comics indexOfObject:comic];
                    }
                }
                weakSelf.navigationItem.title = detail.title;
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.selIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            if ([weakSelf.tableView.mj_header isRefreshing])
            {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        if ([weakSelf.tableView.mj_header isRefreshing])
        {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        [self showText:REQUESTTIPFAI inView:self.view];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detail.comics.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi = @"COMIC_CELL";
    
    UITableViewCell *comicCell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!comicCell) {
        comicCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identi];
    }
    UIColor *tintColor = [UIColor blackColor];
    UITableViewCellAccessoryType type = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == self.selIndex)
    {
        tintColor = THEME_COLOR;
        type = UITableViewCellAccessoryCheckmark;
    }
    comicCell.tintColor = tintColor;
    comicCell.textLabel.textColor = tintColor;
    comicCell.accessoryType = type;
    comicCell.textLabel.text = [(BookComic *)self.detail.comics[indexPath.row] title];
    return comicCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(changeReaderComicWithComicId:)])
    {
        [self.delegate changeReaderComicWithComicId:[(BookComic *)self.detail.comics[indexPath.row] idd]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
