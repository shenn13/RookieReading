//
//  MoreBookViewController.h
//  MoreAndMore
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseTableViewController.h"

#import "BookTextRanking.h"

@interface MoreBookViewController : ZXBaseTableViewController

@property (nonatomic,copy)NSString *method;

@property (nonatomic,assign)RequestType type;

@property (nonatomic,strong)BookTextRanking *ranking;

@end
