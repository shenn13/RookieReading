//
//  BookTextBaseCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextBaseCell.h"

#import "MoreBookViewController.h"
#import "BookTextDetailController.h"

@interface BookTextBaseCell ()<ContentHeaderViewDelegate>

@end

@implementation BookTextBaseCell


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
        
        // 节头
        [self.collectionView registerNib:[UINib nibWithNibName:@"ContentHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CONTENT_HEADER"];
        
        // 子类布局对象属性配置
        [self initCompletionOpration];
    }
    return self;
}

-(void)setRanking:(BookTextRanking *)ranking
{
    _ranking = ranking;
    
    [self.collectionView reloadData];
}

-(void)initCompletionOpration
{
    
}

-(void)contentModelCompletionOpration
{
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookTextDetailController *textBook = [[BookTextDetailController alloc] initWithStyle:UITableViewStyleGrouped];
    textBook.textBook = self.ranking.books[indexPath.row];
    if (indexPath.section == 1)
    {
        textBook.textBook = self.ranking.books[3];
    }
    textBook.hidesBottomBarWhenPushed = YES;
    [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation pushViewController:textBook animated:YES];
}

-(UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _contentLayout = layout;
        
    }
    return _collectionView;
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

-(void)didSelectMoreAction:(ContentHeaderView *)headerView
{
    MoreBookViewController *more = [[MoreBookViewController alloc] initWithStyle:UITableViewStyleGrouped];
    more.ranking = self.ranking;
    more.type = RequestTypeOfZhuiShu;
    more.title = self.rankListModel.title;
    more.hidesBottomBarWhenPushed = YES;
    [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation pushViewController:more animated:YES];
}

@end
