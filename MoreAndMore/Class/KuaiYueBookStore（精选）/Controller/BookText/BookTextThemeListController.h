//
//  BookTextThemeListController.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseTableViewController.h"

#import "RecommendBookModel.h"

@interface BookTextThemeListController : ZXBaseTableViewController

/**
 *  推荐书单
 */
@property (nonatomic,strong)RecommendBookModel *recommend;

@end
