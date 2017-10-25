//
//  BookImageListFilterController.h
//  MoreAndMore
//
//  Created by apple on 16/10/2.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseViewController.h"

#import "TextMenuModel.h"

@interface BookImageListFilterController : ZXBaseViewController

/**
 *  里面是TextMenuModel对象
 */
@property (nonatomic,strong)NSArray *menuAry;

@property (nonatomic,strong)TextMenuModel *menuModel;

@property (nonatomic,assign)NSInteger menuIndex;

@end
