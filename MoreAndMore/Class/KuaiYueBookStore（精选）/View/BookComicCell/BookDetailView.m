//
//  BookDetailView.m
//  MoreAndMore
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookDetailView.h"

#import "PersonalCenterController.h"

#import "BookReaderController.h"

@interface BookDetailView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BookSelectHeaderDelegate,
    CollectionHeaderSortDelegate>

@property (nonatomic,assign)BOOL showProduct;

@property (nonatomic,weak)CollectionHeaderReusableView *headerView;

@end

@implementation BookDetailView

-(instancetype)initWithFrame:(CGRect)frame
{
    JFComicShowBookLayout *headerLayout = [[JFComicShowBookLayout alloc] initWithAnimatedHeight:HEADER_HEIGHT];
    headerLayout.itemSize = CGSizeMake(SCREEN_WIDTH, ITEM_HEIGHT);
    headerLayout.minimumLineSpacing = 0;
    
    if (self = [super initWithFrame:frame collectionViewLayout:headerLayout])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.alwaysBounceVertical = YES;
        self.delegate = self;
        self.dataSource = self;
        
        // 表头（自定义）
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionHeaderReusableView class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:JFHeaderKind withReuseIdentifier:HEADER_IDENTIFIER];
        
        // 节头BookSelectHeader
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([BookSelectHeader class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SECTION_IDENTIFER];
        
        // 单元格
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([BookComicCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:BOOK_DETAIL_IDENTIFIER];
        
        // 介绍区域
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([ProductCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PRODUCT_IDENTIFIER"];
        
        self.showProduct = NO;
        
    }
    return self;
}

-(void)setDetail:(BookDetail *)detail
{
    _detail = detail;
    
    [self reloadData];
}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.showProduct ? 1 : self.detail.comics.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showProduct)
    {
        // 简介页面CELL
        ProductCollectionCell *product = [collectionView dequeueReusableCellWithReuseIdentifier:@"PRODUCT_IDENTIFIER" forIndexPath:indexPath];
        product.backgroundColor = [UIColor whiteColor];
        product.labDescrip.text = self.detail.ddescription;
        [product.userIcon sd_setImageWithURL:[NSURL URLWithString:self.detail.user.avatar_url]];
        product.lanName.text = self.detail.user.nickname;
        return product;
    }
    
    BookComicCell *comicCell = [collectionView dequeueReusableCellWithReuseIdentifier:BOOK_DETAIL_IDENTIFIER forIndexPath:indexPath];
    BookComic *comic = self.detail.comics[indexPath.row];
    comicCell.comic = comic;
    return comicCell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = ITEM_HEIGHT;
    if (self.showProduct)
    {
        height = [ProductCollectionCell productHeight];
    }
    return CGSizeMake(SCREEN_WIDTH, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:JFHeaderKind])
    {
        CollectionHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:JFHeaderKind withReuseIdentifier:HEADER_IDENTIFIER forIndexPath:indexPath];
        headerView.delegate = self;
        headerView.imageHeight = HEADER_HEIGHT;
        headerView.book = self.book;
        reusableView = headerView;
        self.headerView = headerView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        BookSelectHeader *selectedView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SECTION_IDENTIFER forIndexPath:indexPath];
        selectedView.deleagate = self;
        reusableView = selectedView;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if ([collectionViewLayout isKindOfClass:[JFComicShowBookLayout class]])
    {
        return CGSizeMake(SCREEN_WIDTH, 44);
    }
    return CGSizeMake(SCREEN_WIDTH, 44);
}

#pragma mark - 跳转图书阅读界面
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.showProduct)
    {
        BookComic *comic = self.detail.comics[indexPath.row];
        // 阅读界面
        BookReaderController *bookReader = [[BookReaderController alloc] initWithComicId:comic.idd];
        bookReader.hidesBottomBarWhenPushed = YES;
        [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation pushViewController:bookReader animated:YES];
    }
    else
    {
        PersonalCenterController *personVC = [[PersonalCenterController alloc] init];
        personVC.atUserId = self.detail.user.idd;
        personVC.appType = AppApiTypeOfKuaiKan;
        [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation pushViewController:personVC animated:YES];
    }
}

#pragma mark - 展示简介、章节

-(void)didClickShowProduct:(BOOL)show
{
    self.showProduct = show;
    
    self.headerView.btnSort.hidden = self.showProduct;
    
    [self reloadData];
}


#pragma mark - 排序事件

-(void)clickSortActionWithStatus:(BOOL)isAesc
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:isAesc];
    //其中，updated_at为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [self.detail.comics sortUsingDescriptors:sortDescriptors];
    [self reloadData];
    
    [self showTextWithState:ActivityHUDStateSuccess inView:WINDOW text:@"排序成功！"];
}

@end
