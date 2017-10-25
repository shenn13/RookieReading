//
//  FourthBookStoreCell.m
//  MoreAndMore
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "FourthBookStoreCell.h"

@implementation FourthBookStoreCell

-(void)initCompletionOpration
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookSectionFourCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FOURTH_COLLECTION"];
    self.collectionView.scrollEnabled = YES;
    
    self.contentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.contentLayout.minimumLineSpacing = MAR;
    self.contentLayout.minimumInteritemSpacing = MAR;
    self.contentLayout.sectionInset = UIEdgeInsetsMake(0, MAR, MAR, MAR);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookSectionFourCell *fourCell = [BookSectionFourCell sectionFourCell:collectionView atIndexPath:indexPath];
    fourCell.topic = self.storeModel.topics[indexPath.row];
    return fourCell;
}


@end
