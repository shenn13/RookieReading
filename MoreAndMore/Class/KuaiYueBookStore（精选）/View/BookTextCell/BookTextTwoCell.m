//
//  BookTextTwoCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextTwoCell.h"

@implementation BookTextTwoCell

-(void)initCompletionOpration
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookSectionOneCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FIRST_COLLECTION"];
    self.collectionView.scrollEnabled = YES;
    
    self.contentLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.contentLayout.minimumLineSpacing = MAR;
    self.contentLayout.minimumInteritemSpacing = MAR;
    self.contentLayout.sectionInset = UIEdgeInsetsMake(MAR/2, MAR, MAR/2, MAR);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(MIN_TWO_COUNT, self.ranking.books.count);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookSectionOneCell *oneCell = [BookSectionOneCell sectionOneCell:collectionView atIndexPath:indexPath];
    oneCell.textBook = self.ranking.books[indexPath.row];
    return oneCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - MAR * 5)/4, 140 * HSCALE - MAR);
}


@end
