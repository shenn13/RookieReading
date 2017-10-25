//
//  ChalpterDetailModel.m
//  MoreAndMore
//
//  Created by apple on 2017/2/27.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "ChalpterDetailModel.h"

@implementation ChalpterDetailModel

+(ChalpterDetailModel *)toChalpterDetailModel:(NSDictionary *)dict
{
    [ChalpterDetailModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id"};
    }];
    
    return [ChalpterDetailModel objectWithKeyValues:dict];
}

@end
