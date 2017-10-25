//
//  BookTextContentView.m
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextContentView.h"
#import "PublicWebController.h"

#import "BookTextOneCell.h"
#import "BookTextTwoCell.h"
#import "BookTextThreeCell.h"

#import "ZXLoopScrollView.h"
#import "ContentFooterView.h"

#import "AdvertModel.h"

#define ADVERT_IDENTIFIER   @"Advert_Identifier"

@interface BookTextContentView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ZXLoopScrollViewDelegate>

/**
 *  广告栏数据
 */
@property (nonatomic,strong)NSMutableArray *advertAry;

@end


@implementation BookTextContentView


-(instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.alwaysBounceVertical = YES;
        
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifierOther];
        
        // 广告栏
        [self registerClass:[ZXLoopScrollView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ADVERT_IDENTIFIER];
        
        // 第一节
        [self registerClass:[BookTextOneCell class] forCellWithReuseIdentifier:identifierOne_text];
        // 第二节
        [self registerClass:[BookTextTwoCell class] forCellWithReuseIdentifier:identifierTwo_text];
        // 第三节
        [self registerClass:[BookTextThreeCell class] forCellWithReuseIdentifier:identifierThree_text];
        
        // 尾栏
        [self registerNib:[UINib nibWithNibName:@"ContentFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CONTENT_FOOTER"];
        
        self.delegate = self;
        self.dataSource = self;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
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
    return MIN(self.maleRankList.count, 4);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RankListModel *rankListModel = self.maleRankList[indexPath.row];
    
    NSString *identifier = identifierOther;
    if (indexPath.row == 0 || indexPath.row == 3) {
        identifier = identifierOne_text;
    }else if (indexPath.row == 1) {
        identifier = identifierTwo_text;
    }else{
        identifier = identifierThree_text;
    }
    BookTextBaseCell *textBook = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([identifier isEqualToString:identifierOther])
    {
        return textBook;
    }
    textBook.headerView.labTitle.text = rankListModel.title;
    textBook.rankListModel = rankListModel;
    
    if (self.dataAry.count > indexPath.row) {
        textBook.ranking = self.dataAry[indexPath.row];
    }
    return textBook;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = HEADER_MAR;
    if (indexPath.row == 0 || indexPath.row == 3) {
        rowHeight += SECTION_ONE_HEI;
    }else if (indexPath.row == 1){
        rowHeight += SECTION_TWO_HEI;
    }else if (indexPath.row == 2){
        rowHeight += SECTION_THREE_HEI;
    }else{
        rowHeight = 0.f;
    }
    return CGSizeMake(SCREEN_WIDTH, rowHeight);
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
        loop.modelArray = self.advertAry;
        loop.delegate = self;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        resableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CONTENT_FOOTER" forIndexPath:indexPath];
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

#pragma mark - ZXLoopScrollViewDelegate

-(void)loopScrollView:(ZXLoopScrollView *)loopView clickIndex:(NSInteger)index
{
    AdvertModel *model = self.advertAry[index];
    
    PublicWebController *web = [[PublicWebController alloc] init];
    web.detailURL = model.value;
    web.detailTitle = @"书籍详情";
    web.hidesBottomBarWhenPushed = YES;
    [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation pushViewController:web animated:YES];
}

-(NSMutableArray *)dataAry
{
    if (!_dataAry) {
        _dataAry = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataAry;
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

-(NSMutableArray *)advertAry
{
    if (!_advertAry) {
        _advertAry = [NSMutableArray arrayWithCapacity:0];
        NSArray *urlAry = @[
                            @"http://img3.cache.netease.com/news/2016/9/21/201609211759464a404.jpg",
                            @"http://img4.cache.netease.com/news/2016/8/30/20160830112006f1128.jpg",
                            @"http://img4.cache.netease.com/news/2016/9/19/2016091909535922a20.jpg",
                            @"http://img1.cache.netease.com/news/2016/9/9/201609091202350528e.jpg"];
        
        NSArray *htmlAry = @[
                             @"http://yuedu.163.com/source/d6a5e2d8ee0e46f2ae5a08a9b0e22fab_4",
                             @"http://yuedu.163.com/book/subject/ab81538097394797be556a1238b6c2ff",
                             @"http://yuedu.163.com/book/subject/28319897775744e299cd781e40830ae2",
                             @"http://yuedu.163.com/source/bea75ca72fe64957a7e08770865c7e9a_4"
                             ];
        
        for (int i = 0; i < urlAry.count; i++)
        {
            AdvertModel *model = [[AdvertModel alloc] init];
            model.pic = urlAry[i];
            model.value = htmlAry[i];
            [_advertAry addObject:model];
        }
    }
    return _advertAry;
}

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
