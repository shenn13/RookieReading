//
//  HotBookViewController.h
//  MoreAndMore
//
//  Created by Silence on 16/7/15.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface HotBookViewController : ZXBaseViewController

/**
 *  热门（精选）图书书籍籍页面
 */

@property (nonatomic,assign,readonly)BOOL isFromV2List;

-(void)loadDataFromV2:(BOOL)isFromV2;

@end
