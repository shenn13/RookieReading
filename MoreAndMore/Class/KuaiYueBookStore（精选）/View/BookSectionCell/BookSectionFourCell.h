//
//  BookSectionFourCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Topic.h"

@interface BookSectionFourCell : UICollectionViewCell

+(BookSectionFourCell *)sectionFourCell:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong)Topic *topic;


@end
