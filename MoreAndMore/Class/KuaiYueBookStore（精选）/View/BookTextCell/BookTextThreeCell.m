//
//  BookTextThreeCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextThreeCell.h"

@implementation BookTextThreeCell

-(void)initCompletionOpration
{
    [super initCompletionOpration];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookTextSectionThreeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:BOOKTEXT_THREE];
    
    self.collectionView.scrollEnabled = YES;
    
    self.contentLayout.minimumInteritemSpacing = 0;
    self.contentLayout.minimumLineSpacing = 0;
    self.contentLayout.sectionInset = UIEdgeInsetsMake(0, MAR, MAR, MAR);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(MIN_THREE_COUNT, self.ranking.books.count);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookTextSectionThreeCell *sectionThree = [collectionView dequeueReusableCellWithReuseIdentifier:BOOKTEXT_THREE forIndexPath:indexPath];
    
    sectionThree.textBook = self.ranking.books[indexPath.row];
    
    return sectionThree;
}

// 三列
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, 110);
}

@end
