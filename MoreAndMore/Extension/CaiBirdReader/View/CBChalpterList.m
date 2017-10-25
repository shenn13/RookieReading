//
//  CBChalpterList.m
//  MoreAndMore
//
//  Created by apple on 2017/2/27.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "CBChalpterList.h"

@interface CBChalpterList ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)UITableView *tableView;

// 顶部栏
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UISegmentedControl *headerSeg;
// 底部栏
@property (nonatomic,strong)UILabel *footerView;

@end

@implementation CBChalpterList

-(instancetype)init
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        // 毛玻璃背景
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:visualEfView];
        
        CGFloat maxW = SCREEN_WIDTH * 0.75;
        CGFloat toolH = 40.f;
        // 头部
        [self headerView];
        self.listType = ChalpterListTypeChalpter;
        // 底部栏
        self.footerView.frame = CGRectMake(0, SCREEN_HEIGHT - 40.f, maxW, toolH);
        // 列表
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, maxW, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        _tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:234/255.0 alpha:1.0];
        _tableView.rowHeight = 50.f;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        
        // Dismiss手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chalpterListDismissAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [self addGestureRecognizer:tap];

        kSelfWeak;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (weakSelf.headerSeg.selectedSegmentIndex == 0) {
                [self initWithChalpterListRequest];
            }else{
                [self initWithSummaryListRequest];
            }
        }];
        [self hiddenChalpterListView:NO];
    }
    return self;
}

#pragma makr - 显示/隐藏

-(void)showChalpterListView:(BOOL)animated
{
    self.userInteractionEnabled = YES;
    if (self.chalpterList == nil)
    {
        // 如果章节列表为空
        [self initWithSummaryListRequest];
    }
    CGFloat newX = 0.f;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.mj_x = newX;
        }];
    }else{
        self.mj_x = newX;
    }
}

-(void)hiddenChalpterListView:(BOOL)animated
{
    self.userInteractionEnabled = NO;
    CGFloat newX = -self.frame.size.width;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.mj_x = newX;
        }];
    }else{
        self.mj_x = newX;
    }
}

-(void)chalpterListDismissAction:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:self];
    CGRect listRect = [self convertRect:self.tableView.bounds fromView:self.tableView];
    if (!CGRectContainsPoint(listRect, touchPoint)) {
        [self hiddenChalpterListView:YES];
    }
}

#pragma mark - 列表类型切换
-(void)listTypeChangeAction:(UISegmentedControl *)headerSeg
{
    self.listType = headerSeg.selectedSegmentIndex;
}

-(void)setListType:(ChalpterListType)listType
{
    _listType = listType;
    self.headerSeg.selectedSegmentIndex = listType;
    [self.tableView reloadData];
}

#pragma makr - 加载数据<公共方法>

-(void)loadDataWithBookID:(NSString *)textBookId
{
    self.textBookId = textBookId;
    
    [self initWithSummaryListRequest];
}

#pragma mark - 获取书籍<数据源>对象

-(void)initWithSummaryListRequest
{
    if (self.textBookId.length < 1)
    {
        [self showTextWithState:ActivityHUDStateFailed inView:self.superview text:@"很抱歉\n此书籍不存在或已被删除！"];
        [self endRefresh];
        return;
    }
    
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfSeven param:nil] requestType:RequestTypeOfZhuiShu params:@{@"book":self.textBookId,@"view":@"summary"} completion:^(NSDictionary *responseObject) {
        if (responseObject.count > 0)
        {
            weakSelf.summaryAry = [[SummaryTextModel toSummaryModelAry:(NSArray *)responseObject] mutableCopy];
            if (weakSelf.summaryIndex < weakSelf.summaryAry.count) {
                weakSelf.summaryModel = weakSelf.summaryAry[weakSelf.summaryIndex];
            }
            if (weakSelf.listType == ChalpterListTypeSource) {
                [self.tableView reloadData];
            }
            // 获取章节列表
            [weakSelf initWithChalpterListRequest];
        }
        else
        {
            [weakSelf endRefresh];
        }
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
    }];
}

-(void)setSummaryModel:(SummaryTextModel *)summaryModel
{
    _summaryModel = summaryModel;
    
    self.footerView.text = [NSString stringWithFormat:@"%@<%@>",summaryModel.name,summaryModel.source];
}

#pragma mark - 获取章节列表数据

-(void)initWithChalpterListRequest
{
    if (self.summaryModel.idd.length < 1)
    {
        [self showTextWithState:ActivityHUDStateFailed inView:self.superview text:@"很抱歉\n此章节不存在或已被删除！"];
        [self endRefresh];
        return;
    }
    
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfEight param:@{@"summaryId":self.summaryModel.idd}] requestType:RequestTypeOfZhuiShu params:@{@"view":@"chapters"} completion:^(NSDictionary *responseObject) {
        if (responseObject.count > 0)
        {
            weakSelf.chalpterList = [ChalpterTextListModel toChalpterListModel:responseObject];
            if (weakSelf.chalpterIndex < weakSelf.chalpterList.chapters.count) {
                weakSelf.chalperModel = weakSelf.chalpterList.chapters[weakSelf.chalpterIndex];
                // 加载默认章节
                [weakSelf loadChalpterDetailText:weakSelf.chalperModel];
            }
            [weakSelf.tableView reloadData];
        }
        [weakSelf endRefresh];
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
    }];
}

#pragma mark - 上一章、下一章
-(void)loadChalpterDetailWithNewChalpter:(NSInteger)chalpter
{
    if (chalpter < 0) {
        [self showText:@"当前已经是第一章!" inView:self.superview];
        return;
    }
    if (chalpter >= self.chalpterList.chapters.count) {
        [self showText:@"当前已经是最终章!" inView:self.superview];
        return;
    }
    self.chalpterIndex = chalpter;
    self.chalperModel = self.chalpterList.chapters[self.chalpterIndex];
    // 请求章节数据
    [self loadChalpterDetailText:self.chalperModel];
}

-(void)endRefresh
{
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
}

#pragma mark -  获取章节<文本数据>
-(void)loadChalpterDetailText:(ChalpterTextModel *)textModel
{
    if (self.chalperModel == nil) {
        [self showTextWithState:ActivityHUDStateFailed inView:self.superview text:@"很抱歉\n此章节不存在或已被删除！"];
        return;
    }
    NSString *readerProgress = [NSString stringWithFormat:@"当前进度：%.2f%% ",(CGFloat)self.chalpterIndex/(CGFloat)self.chalpterList.chapters.count*100.f];
    [self startActivityWithText:readerProgress];
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfFifteen param:@{@"chalpterLink":textModel.link}] requestType:RequestTypeOfZhuiShuChalpter params:nil completion:^(NSDictionary *responseObject) {
        ActivityHUDState state = ActivityHUDStateFailed;
        ChalpterDetailModel *detailModel = nil;
        if (responseObject.count > 0)
        {
            detailModel = [ChalpterDetailModel toChalpterDetailModel:responseObject[@"chapter"]];
            state = ActivityHUDStateSuccess;
        }
        if (weakSelf.ChalpterLoadCompletion) {
            weakSelf.ChalpterLoadCompletion(detailModel);
        }
        [weakSelf endRefresh];
        [weakSelf stopActivityWithText:REQUESTTIPSUC state:state];
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
        [weakSelf stopActivityWithText:REQUESTTIPFAI state:ActivityHUDStateFailed];
    }];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.headerSeg.selectedSegmentIndex == 0 ? self.chalpterList.chapters.count : self.summaryAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi_chalpter = @"COMIC_CELL_CHALPTER";
    static NSString *identi_summary = @"COMIC_CELL_sUMMARY";

    NSString *identifier = self.listType == ChalpterListTypeChalpter ? identi_chalpter : identi_summary;
    
    UITableViewCell *comicCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!comicCell) {
        UITableViewCellStyle style = self.listType == ChalpterListTypeChalpter ? UITableViewCellStyleValue1 : UITableViewCellStyleSubtitle;
        comicCell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:identifier];
        comicCell.backgroundColor = [UIColor clearColor];
    }
    
    UIColor *tintColor = [UIColor blackColor];
    UITableViewCellAccessoryType type = UITableViewCellAccessoryDisclosureIndicator;
    if ((indexPath.row == self.summaryIndex && self.listType == ChalpterListTypeSource) ||
        (indexPath.row == self.chalpterIndex && self.listType == ChalpterListTypeChalpter))
    {
        tintColor = THEME_COLOR;
        type = UITableViewCellAccessoryCheckmark;
    }
    comicCell.tintColor = tintColor;
    comicCell.textLabel.textColor = tintColor;
    comicCell.detailTextLabel.textColor = [UIColor grayColor];
    comicCell.accessoryType = type;
    if (self.listType == ChalpterListTypeChalpter)
    {
        // 章节目录
        ChalpterTextModel *chapter = self.chalpterList.chapters[indexPath.row];
        comicCell.textLabel.text = chapter.title;
    }
    else
    {
        // 书籍源
        SummaryTextModel *summaryModel = self.summaryAry[indexPath.row];
        comicCell.textLabel.text = summaryModel.host;
        comicCell.detailTextLabel.text = summaryModel.lastChapter;
    }
    return comicCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.headerSeg.selectedSegmentIndex == 0)
    {
        // 选择章节
        if (indexPath.row < self.chalpterList.chapters.count && indexPath.row != self.chalpterIndex)
        {
            self.chalpterIndex = indexPath.row;
            self.chalperModel = self.chalpterList.chapters[indexPath.row];
        }
        [self loadChalpterDetailText:self.chalperModel];
        [self hiddenChalpterListView:YES];
    }
    else
    {
        // 选择书籍源
        if (indexPath.row < self.summaryAry.count && indexPath.row != self.summaryIndex)
        {
            self.summaryModel = self.summaryAry[indexPath.row];
            self.summaryIndex = indexPath.row;
            self.chalpterIndex = 0;
            [self initWithChalpterListRequest];
        }
        // 选中源之后,切换到目录
        self.listType = ChalpterListTypeChalpter;
    }
}

#pragma mark - 手势相关代理<处理手势冲突>

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        //判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;
    }
    return YES;
}

#pragma mark - 懒加载

-(UIView *)headerView{
    if (_headerView == nil) {
        CGFloat maxW = SCREEN_WIDTH * 0.75;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxW, 64.f)];
        _headerView.backgroundColor = [UIColor clearColor];
        
        self.headerSeg.frame = CGRectMake(15.f, 24, maxW - 30, 36.f);
        [_headerView addSubview:self.headerSeg];
    }
    return _headerView;
}

-(UISegmentedControl *)headerSeg{
    if (_headerSeg == nil) {
        _headerSeg = [[UISegmentedControl alloc] initWithItems:@[@"目录",@"换源"]];
        
        [_headerSeg setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f]} forState:UIControlStateNormal];
        _headerSeg.tintColor = THEME_COLOR;
        _headerSeg.backgroundColor = [UIColor clearColor];
        [_headerSeg addTarget:self action:@selector(listTypeChangeAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _headerSeg;
}

-(UILabel *)footerView{
    if (_footerView == nil) {
        _footerView = [[UILabel alloc] init];
        _footerView.backgroundColor = [UIColor clearColor];
        _footerView.textColor = [UIColor redColor];
        _footerView.font = [UIFont boldSystemFontOfSize:17];
        _footerView.textAlignment = NSTextAlignmentCenter;
    }
    return _footerView;
}

@end
