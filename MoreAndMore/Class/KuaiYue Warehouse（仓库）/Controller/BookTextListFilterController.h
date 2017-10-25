//
//  BookTextListFilterController.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseViewController.h"

#import "TextMenuModel.h"

@interface BookTextListFilterController : ZXBaseViewController

@property (nonatomic,strong)TextMenuModel *menuModel;

@property (nonatomic,strong)NSMutableArray *menuList;

@end
