//
//  RankListModel.m
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "RankListModel.h"

@implementation RankListModel

+(NSArray *)toRankList:(NSArray *)ary
{
    [RankListModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    return [RankListModel objectArrayWithKeyValuesArray:ary];
}

@end
