//
//  FirstBookStoreCell.m
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "FirstBookStoreCell.h"
#import "BookSectionOneCell.h"

@implementation FirstBookStoreCell

-(void)initCompletionOpration
{
    [super initCompletionOpration];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookSectionOneCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FIRST_COLLECTION"];
    self.collectionView.scrollEnabled = YES;
    
    self.contentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.contentLayout.minimumLineSpacing = MAR;
    self.contentLayout.minimumInteritemSpacing = MAR;
    self.contentLayout.sectionInset = UIEdgeInsetsMake(0, MAR, MAR, MAR);
}

-(void)contentModelCompletionOpration
{
    UICollectionViewScrollDirection direction = UICollectionViewScrollDirectionHorizontal;
    BOOL scrollPage = NO;
    if ([self.reuseIdentifier isEqualToString:identifierOne])
    {
        // 滚动方向
        direction = UICollectionViewScrollDirectionVertical;
        // 是否分页
        scrollPage = YES;
    }
    
    self.contentLayout.scrollDirection = direction;
    self.collectionView.pagingEnabled = scrollPage;
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookSectionOneCell *oneCell = [BookSectionOneCell sectionOneCell:collectionView atIndexPath:indexPath];
    oneCell.topic = self.storeModel.topics[indexPath.row];
    return oneCell;
}


@end
