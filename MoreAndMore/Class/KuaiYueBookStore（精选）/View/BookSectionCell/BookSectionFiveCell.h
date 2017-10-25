//
//  BookSectionFiveCell.h
//  MoreAndMore
//
//  Created by Silence on 16/7/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Banner.h"

@interface BookSectionFiveCell : UICollectionViewCell

+(BookSectionFiveCell *)sectionFiveCell:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong)Banner *banner;

@end
