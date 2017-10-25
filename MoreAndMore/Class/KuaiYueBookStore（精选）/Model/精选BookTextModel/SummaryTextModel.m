//
//  SummaryTextModel.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "SummaryTextModel.h"

@implementation SummaryTextModel

+(NSArray *)toSummaryModelAry:(NSArray *)ary
{
    [SummaryTextModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    return [SummaryTextModel objectArrayWithKeyValuesArray:ary];
}

@end
