//
//  BookStoreBaseCell.m
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookStoreBaseCell.h"

#import "BookDetailViewController.h"
#import "MoreBookViewController.h"
#import "BookReaderController.h"

@implementation BookStoreBaseCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self.headerView removeFromSuperview];
        [self.collectionView removeFromSuperview];
        
        self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEADER_MAR);
        
        [self addSubview:self.headerView];
        self.collectionView.frame = CGRectMake(0, HEADER_MAR, SCREEN_WIDTH, VIEW_HEIGHT(self) - HEADER_MAR);
        
        [self addSubview:self.collectionView];

        // 子类布局对象属性配置
        [self initCompletionOpration];
    }
    return self;
}

-(void)initCompletionOpration
{
    
}

-(void)contentModelCompletionOpration
{
    [self.collectionView reloadData];
}

-(ContentHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"ContentHeaderView" owner:nil options:nil][0];
        _headerView.delegate = self;
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _contentLayout = layout;
    }
    return _collectionView;
}

#pragma mark - 获取ItemSize

+(CGSize)itemSizeWithIdentifier:(NSString *)identifier
{
    NSInteger minColumn = 1;
    CGFloat columnSpacer = (minColumn + 1) * minColumn;
    if ([identifier isEqualToString:identifierOne])
    {
        // 三列多行
        minColumn = 3;
        columnSpacer = (minColumn + 1) * MAR;
        return CGSizeMake((SCREEN_WIDTH - columnSpacer)/minColumn, 150.f * HSCALE);
    }
    else if ([identifier isEqualToString:identifierOneSpec])
    {
        // 至少两列
        minColumn = 2;
        columnSpacer = (minColumn + 1) * MAR;
        CGFloat extW = 30.f;
        return  CGSizeMake((SCREEN_WIDTH - columnSpacer - extW)/minColumn, 150.f);
    }
    else if ([identifier isEqualToString:identifierTwo])
    {
        // 一列三行,横向滑动
        CGFloat extW = 60.f;
        return CGSizeMake(SCREEN_WIDTH - extW, 60.f);
    }
    else if ([identifier isEqualToString:identifierThree])
    {
        // 一列多行(横向大图)
        return CGSizeMake(SCREEN_WIDTH - columnSpacer , 80.f);
    }
    else if ([identifier isEqualToString:identifierFour])
    {
        return CGSizeMake(SCREEN_WIDTH * 0.75, 140.f);
    }
    else if ([identifier isEqualToString:identifierFive])
    {
        minColumn = 2;
        columnSpacer = (minColumn + 1) * MAR;
        return CGSizeMake((SCREEN_WIDTH - columnSpacer)/minColumn, 100.f);
    }
    
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.storeModel.topics.count < 1)
    {
        return self.storeModel.banners.count;;
    }
    return self.storeModel.topics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [BookStoreBaseCell itemSizeWithIdentifier:self.reuseIdentifier];
}

#pragma mark cell点击事件（进入漫画详情界面)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"漫画详情界面加载" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"漫画1",@"漫画2", nil];
    [sheet showWithCompleteBlock:^(NSInteger buttonIndex) {
        NSLog(@"点击了第（%ld）个",buttonIndex);
    }];
     */

    // 官方活动是进入阅读页面
    if (self.storeModel.item_type == 6 && indexPath.row < self.storeModel.banners.count)
    {
        //[self showText:@"官方活动阅读" inView:WINDOW];
        BookReaderController *bookReader = [[BookReaderController alloc] initWithComicId:[self.storeModel.banners[indexPath.row] idd]];
        bookReader.hidesBottomBarWhenPushed = YES;
        [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation pushViewController:bookReader animated:YES];
        return;
    }
    
    // 漫画详情界面
    Topic *topic = self.storeModel.topics[indexPath.row];
    topic.order = 0; // 默认倒序排序
    BookDetailViewController *bookDetail = [[BookDetailViewController alloc] init];
    bookDetail.book = topic;
    bookDetail.hidesBottomBarWhenPushed = YES;
    [JUMP_MANAGER.jumpNavigation pushViewController:bookDetail animated:YES];
}

#pragma mark 更多按钮点击事件
-(void)didSelectMoreAction:(ContentHeaderView *)headerView
{
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更多漫画页面加载" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showWithCompleteBlock:^(NSInteger buttonIndex) {
        NSLog(@"点击了第（%ld）个",buttonIndex);
    }];
    */
    MoreBookViewController *more = [[MoreBookViewController alloc] initWithStyle:UITableViewStyleGrouped];
    more.method = self.storeModel.action;
    more.navigationItem.title = self.storeModel.title;
    more.hidesBottomBarWhenPushed = YES;
    [JUMP_MANAGER.jumpNavigation pushViewController:more animated:YES];
}

-(void)setStoreModel:(StoreListModel *)storeModel
{
    _storeModel = storeModel;
    
    self.headerView.labTitle.text = storeModel.title;
    
    self.headerView.btnMore.hidden = !storeModel.more_flag;

    [self contentModelCompletionOpration];
}

@end
