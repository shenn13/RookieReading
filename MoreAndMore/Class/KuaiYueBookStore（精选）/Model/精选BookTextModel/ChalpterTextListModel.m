//
//  ChalpterTextListModel.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ChalpterTextListModel.h"

@implementation ChalpterTextListModel

+(ChalpterTextListModel *)toChalpterListModel:(NSDictionary *)dict
{
    [ChalpterTextListModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    [ChalpterTextModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id"};
    }];
    
    [ChalpterTextListModel setupObjectClassInArray:^NSDictionary *{
        return @{@"chapters":@"ChalpterTextModel"};
    }];
    
    return [ChalpterTextListModel objectWithKeyValues:dict];
}

@end
