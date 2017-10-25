//
//  BookStoreListView.m
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookStoreListView.h"

#import "BookReaderController.h"

#define ADVERT_IDENTIFIER @"Advert_Identifier"
#define FOTTER_POST       @"CONTENT_FOOTER"

@interface BookStoreListView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZXLoopScrollViewDelegate>

@end

@implementation BookStoreListView

-(instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.alwaysBounceVertical = YES;

        // 广告栏
        [self registerClass:[ZXLoopScrollView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ADVERT_IDENTIFIER];
        // 尾栏
        [self registerNib:[UINib nibWithNibName:@"ContentFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOTTER_POST];
        
        // 第一节/第四节单元格区
        [self registerClass:[FirstBookStoreCell class] forCellWithReuseIdentifier:identifierOne];
        [self registerClass:[FirstBookStoreCell class] forCellWithReuseIdentifier:identifierOneSpec];
        // 第二节单元格区域
        [self registerClass:[SecondBookStoreCell class] forCellWithReuseIdentifier:identifierTwo];
        // 第三节单元格区域
        [self registerClass:[ThirdBookStoreCell class] forCellWithReuseIdentifier:identifierThree];
        // 第五节单元格区域
        [self registerClass:[FifthBookStoreCell class] forCellWithReuseIdentifier:identifierFive];
        // V2新样式单元格
        [self registerClass:[FourthBookStoreCell class] forCellWithReuseIdentifier:identifierFour];
        
        self.delegate = self;
        self.dataSource = self;
        
    }
    return self;
}

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listArr.count == 0) {
        return nil;
    }
    StoreListModel *storeModel = self.listArr[indexPath.row];
    
    NSString *identi = [self getIdentifierWithIndexPath:indexPath];
    
    BookStoreBaseCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:identi forIndexPath:indexPath];
    [contentCell setValue:storeModel forKey:@"storeModel"];
    return contentCell;
}

#pragma marrk - 获取cell重用标识

-(NSString *)getIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    StoreListModel *model = self.listArr[indexPath.row];
    
    switch (model.item_type)
    {
        case 7:
            return identifierOneSpec;
            break;
        case 2:
            return  identifierTwo;
            break;
        case 6:  // 官方
            return  identifierFive;
            break;
        case 9:
            return  identifierThree;
            break;
        case 5:  // V2新样式（横向 大）
            return  identifierFour;
        default:
            return  identifierOne;
            break;
    }
}

#pragma mark - 根据itemType获取节高
-(CGSize)rowSectionHeightWithModel:(StoreListModel *)listModel
{
    NSInteger minRow = 1;
    CGFloat rowSpacer = (minRow - 1) * MAR;
    CGFloat height = HEADER_MAR + MAR;
    if (listModel.item_type == 4) {
        // 三列多行<120.f>
        minRow = 2;
        rowSpacer = (minRow - 1) * MAR;
        height +=  150.f * HSCALE * minRow + rowSpacer;
    }
    else if (listModel.item_type == 7){
        // 三列一行<120.f>
        height += 150.f + MAR;
    }
    else if (listModel.item_type == 5){
        // 一行多列
        height += 140.f;
    }
    else if (listModel.item_type == 2){
        // 多列三行
        minRow = 3;
        rowSpacer = (minRow - 1) * MAR;
        height += 60.f * minRow + rowSpacer;
    }
    else if (listModel.item_type == 6){
        // 官方活动<样式>
        height += 100.f;
    }
    else if(listModel.item_type == 9){
        // 一列多行<长图片>
        minRow = 2;
        rowSpacer = minRow * MAR;
        height += 80.f * minRow + rowSpacer;
    }
    return CGSizeMake(SCREEN_WIDTH,height);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreListModel *listModel = self.listArr[indexPath.row];
    return [self rowSectionHeightWithModel:listModel];
}

#pragma mark - 节头结尾

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *resableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section == 0)
    {
        resableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ADVERT_IDENTIFIER forIndexPath:indexPath];
        ZXLoopScrollView *loop = (ZXLoopScrollView *)resableView;
        loop.layer.masksToBounds = YES;
        loop.modelArray = self.advertArray;
        loop.delegate = self;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        resableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOTTER_POST forIndexPath:indexPath];
    }
    return resableView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 120);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 64);
}

#pragma mark - 广告栏点击事件
-(void)loopScrollView:(ZXLoopScrollView *)loopView clickIndex:(NSInteger)index
{
    if (loopView.modelArray.count > 0 && loopView.modelArray.count > index)
    {
        id model = loopView.modelArray[index];
        if ([model isKindOfClass:[Banner class]])
        {
            NSString *comicId = [(Banner *)model target_id];
            BookReaderController *bookReader = [[BookReaderController alloc] initWithComicId:comicId];
            bookReader.hidesBottomBarWhenPushed = YES;
            [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation pushViewController:bookReader animated:YES];
        }
    }
}

#pragma mark - 导航栏处理
/*
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSet = self.contentOffset.y;
    
    if (offSet <= 0 && JUMP_MANAGER.jumpNavigation.navigationBarHidden)
    {
        [JUMP_MANAGER.jumpNavigation setNavigationBarHidden:NO animated:YES];
        
        [self.topLayer removeFromSuperlayer];
    }
    else if (offSet > 0 && !JUMP_MANAGER.jumpNavigation.navigationBarHidden)
    {
        [JUMP_MANAGER.jumpNavigation setNavigationBarHidden:YES animated:YES];
        
        [self.superview.layer addSublayer:self.topLayer];
    }
}
*/

#pragma mark 顶部状态栏遮罩
-(CALayer *)topLayer
{
    if (!_topLayer) {
        _topLayer = [CALayer layer];
        _topLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 21);
        _topLayer.backgroundColor = THEME_COLOR.CGColor;
    }
    return _topLayer;
}

@end
