//
//  TextMenuModel.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "TextMenuModel.h"

@implementation TextMenuModel

+(NSMutableArray *)toMenuModelAry:(NSArray *)ary
{
    NSMutableArray *newAry = [TextMenuModel objectArrayWithKeyValuesArray:ary];
    for (TextMenuModel *menu in newAry)
    {
        menu.type = AppApiTypeOfZhuiShu;
    }
    return newAry;
}

@end
