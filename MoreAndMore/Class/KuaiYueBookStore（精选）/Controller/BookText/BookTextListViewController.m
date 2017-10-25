//
//  BookTextListViewController.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextListViewController.h"
#import "CBReaderPageController.h"

#import "SummaryTextModel.h"
#import "ChalpterTextListModel.h"

@interface BookTextListViewController ()

@property (nonatomic,strong)NSMutableArray *summaryAry;

@property (nonatomic,strong)ChalpterTextListModel *listModel;

@property (nonatomic,assign)NSInteger sort;

@end

@implementation BookTextListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 50.f;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    if (self.type == BookTextListTypeOfSummary)
    {
        self.navigationItem.title = @"选择书籍源";
        // 书籍数据源列表获取
        [self initWithSummaryListRequest];
    }
    else
    {
        self.navigationItem.title = @"章节列表";
        // 书籍章节列表获取
        [self initWithChalpterListRequest];
        
        [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[@"tips_menu_desc"] selArr:nil];
    }
}

#pragma mark - 排序

-(void)rightBarItemClick:(UIButton *)rightItem
{
    if (self.listModel.chapters.count < 1) return;
    
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
    
    /**
     *  将数组元素倒置
     */
    self.listModel.chapters = [[[self.listModel.chapters reverseObjectEnumerator] allObjects] mutableCopy];
    [self.tableView reloadData];
    
    self.selIndex = 0;
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self showTextWithState:ActivityHUDStateSuccess inView:WINDOW text:@"排序成功！"];
}


#pragma mark - 先获取书籍<数据源>对象

-(void)initWithSummaryListRequest
{
    if (self.textBookId.length < 1)
    {
        [self showTextWithState:ActivityHUDStateFailed inView:self.navigationController.view text:@"很抱歉\n此书籍不存在或已被删除！"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfSeven param:nil] requestType:RequestTypeOfZhuiShu params:@{@"book":self.textBookId,@"view":@"summary"} completion:^(NSDictionary *responseObject) {
        if (responseObject.count > 0)
        {
            weakSelf.summaryAry = [[SummaryTextModel toSummaryModelAry:(NSArray *)responseObject] mutableCopy];
            
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取章节列表数据

-(void)initWithChalpterListRequest
{
    if (self.summaryModel.idd.length < 1)
    {
        [self showTextWithState:ActivityHUDStateFailed inView:self.navigationController.view text:@"很抱歉\n此章节不存在或已被删除！"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfEight param:@{@"summaryId":self.summaryModel.idd}] requestType:RequestTypeOfZhuiShu params:@{@"view":@"chapters"} completion:^(NSDictionary *responseObject) {
        if (responseObject.count > 0)
        {
            weakSelf.listModel = [ChalpterTextListModel toChalpterListModel:responseObject];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == BookTextListTypeOfSummary)
    {
        return self.summaryAry.count;
    }
    else
    {
        return self.listModel.chapters.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi = @"COMIC_CELL";
    
    UITableViewCell *comicCell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!comicCell) {
        UITableViewCellStyle cellStyle = self.type == BookTextListTypeOfSummary ? UITableViewCellStyleSubtitle : UITableViewCellStyleValue1;
        
        comicCell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:identi];
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
    comicCell.detailTextLabel.textColor = [UIColor grayColor];
    comicCell.accessoryType = type;
    
    if (self.type == BookTextListTypeOfSummary)
    {
        SummaryTextModel *summaryModel = self.summaryAry[indexPath.row];
        
        comicCell.textLabel.text = summaryModel.host;
        comicCell.detailTextLabel.text = summaryModel.lastChapter;
    }
    else
    {
        ChalpterTextModel *chapter = self.listModel.chapters[indexPath.row];
        comicCell.textLabel.text = chapter.title;
    }
    
    return comicCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == BookTextListTypeOfSummary)
    {
        SummaryTextModel *summaryModel = self.summaryAry[indexPath.row];
        
        if (!summaryModel) return;

        BookTextListViewController *textList = [[BookTextListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        textList.type = BookTextListTypeOfChalpter;
        textList.textBookId = self.textBookId;
        textList.summaryModel = summaryModel;
        textList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:textList animated:YES];
    }
    else
    {
        if (self.summaryModel.idd.length < 1)
        {
            [self showTextWithState:ActivityHUDStateFailed inView:self.navigationController.view text:@"很抱歉\n此章节不存在或已被删除！"];
            return;
        }
        CBReaderPageController *CBReader = [[CBReaderPageController alloc] init];
        CBReader.textBookId = self.textBookId;
        [self presentViewController:CBReader animated:YES completion:nil];
    }
    
    self.selIndex = indexPath.row;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
