//
//  ZXBaseTableViewController.h
//  MoreAndMore
//
//  Created by Silence on 16/6/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ZXStyle.h"

@interface ZXBaseTableViewController : UITableViewController

@property (nonatomic,strong)NSMutableArray *dataSource;

-(BOOL)hideNavigationBottomLine;

@end
