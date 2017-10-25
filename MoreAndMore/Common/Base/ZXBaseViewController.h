//
//  ZXBaseViewController.h
//  MoreAndMore
//
//  Created by Silence on 16/6/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ZXStyle.h"
#import "ZXShowWaitView.h"

@interface ZXBaseViewController : UIViewController

@property (nonatomic,strong)NSMutableArray *dataSource;

-(BOOL)hideNavigationBottomLine;

@end
