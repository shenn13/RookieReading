//
//  BookTextOneCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextOneCell.h"

@implementation BookTextOneCell

-(void)initCompletionOpration
{
    [super initCompletionOpration];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookTextSectionOneCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:BOOKTEXT_ONE];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookTextSectionTwoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:BOOKTEXT_TWO];
    
    self.collectionView.scrollEnabled = YES;

    self.contentLayout.minimumInteritemSpacing = MAR;
    self.contentLayout.minimumLineSpacing = MAR/2;
    self.contentLayout.sectionInset = UIEdgeInsetsMake(MAR/2, MAR, MAR/2, MAR);
}

-(void)contentModelCompletionOpration
{
    // 上排三个 + 下排详情
    self.contentLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SECTION_ONE_HEI);
    [self.collectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.ranking.books.count > MIN_ONE_COUNT) {
        return 2;
    }
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return MIN(MIN_ONE_COUNT, self.ranking.books.count);
    }
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        BookTextSectionTwoCell *sectionTwo = [collectionView dequeueReusableCellWithReuseIdentifier:BOOKTEXT_TWO forIndexPath:indexPath];
        
        sectionTwo.textBook = self.ranking.books[indexPath.row];
        
        return sectionTwo;
    }
    BookTextSectionOneCell *sectionOne = [collectionView dequeueReusableCellWithReuseIdentifier:BOOKTEXT_ONE forIndexPath:indexPath];
    
    sectionOne.textBook = self.ranking.books[MIN_ONE_COUNT];
    
    return sectionOne;
}

// 三列
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat showHei = SECTION_ONE_HEI - MAR * 2;
    
    if(indexPath.section == 0)
    {
        return CGSizeMake((SCREEN_WIDTH - MAR * 4)/3,showHei * 0.6);
    }
    return CGSizeMake(SCREEN_WIDTH - MAR * 2, showHei * 0.4);
}

@end
