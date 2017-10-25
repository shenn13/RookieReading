//
//  BookSectionTwoCell.h
//  MoreAndMore
//
//  Created by Silence on 16/7/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface BookSectionTwoCell : UICollectionViewCell

+(BookSectionTwoCell *)sectionTwoCell:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong)Topic *topic;

@end
