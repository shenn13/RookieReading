//
//  ThirdBookStoreCell.m
//  MoreAndMore
//
//  Created by Silence on 16/7/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ThirdBookStoreCell.h"

@implementation ThirdBookStoreCell

-(void)initCompletionOpration
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookSectionThreeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"THIRD_COLLECTION"];
    self.collectionView.scrollEnabled = YES;
    
    self.contentLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.contentLayout.minimumLineSpacing = MAR;
    self.contentLayout.minimumInteritemSpacing = MAR;
    self.contentLayout.sectionInset = UIEdgeInsetsMake(0, MAR, MAR, MAR);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookSectionThreeCell *threeCell = [BookSectionThreeCell sectionThreeCell:collectionView atIndexPath:indexPath];
    threeCell.topic = self.storeModel.topics[indexPath.row];
    return threeCell;
}


@end
