//
//  FifthBookStoreCell.m
//  MoreAndMore
//
//  Created by Silence on 16/7/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "FifthBookStoreCell.h"

@implementation FifthBookStoreCell

-(void)initCompletionOpration
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookSectionFiveCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FIFTH_COLLECTION"];
    self.collectionView.scrollEnabled = YES;
    
    self.contentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.contentLayout.minimumLineSpacing = MAR;
    self.contentLayout.minimumInteritemSpacing = MAR;
    self.contentLayout.sectionInset = UIEdgeInsetsMake(0, MAR, MAR, MAR);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookSectionFiveCell *fiveCell = [BookSectionFiveCell sectionFiveCell:collectionView atIndexPath:indexPath];
    fiveCell.banner = self.storeModel.banners[indexPath.row];
    return fiveCell;
}


@end
