//
//  SecondBookStoreCell.m
//  MoreAndMore
//
//  Created by Silence on 16/7/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "SecondBookStoreCell.h"

@implementation SecondBookStoreCell

-(void)initCompletionOpration
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookSectionTwoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SECOND_COLLECTION"];
    self.collectionView.scrollEnabled = YES;
    
    self.contentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.contentLayout.minimumLineSpacing = MAR;
    self.contentLayout.minimumInteritemSpacing = MAR;
    self.contentLayout.sectionInset = UIEdgeInsetsMake(0, MAR, MAR, MAR);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookSectionTwoCell *twoCell = [BookSectionTwoCell sectionTwoCell:collectionView atIndexPath:indexPath];
    twoCell.topic = self.storeModel.topics[indexPath.row];
    return twoCell;
}


@end
