//
//  BookSectionOneCell.h
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookStoreBaseCell.h"

#import "Topic.h"
#import "TextBook.h"

@interface BookSectionOneCell : UICollectionViewCell

+(BookSectionOneCell *)sectionOneCell:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong)Topic *topic;

@property (nonatomic,strong)TextBook *textBook;

@end
