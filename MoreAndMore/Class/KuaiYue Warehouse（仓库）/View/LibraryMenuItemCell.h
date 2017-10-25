//
//  LibraryMenuItemCell.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LIBRARY_MENU    @"LIBRARY_MENU"

#import "TextMenuModel.h"

@interface LibraryMenuItemCell : UICollectionViewCell

@property (nonatomic,strong)TextMenuModel *menuModel;

@end
