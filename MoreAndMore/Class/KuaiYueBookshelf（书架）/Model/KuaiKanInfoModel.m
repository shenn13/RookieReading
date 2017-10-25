//
//  KuaiKanInfoModel.m
//  MoreAndMore
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "KuaiKanInfoModel.h"
#import "MJExtension.h"
#import "NSObject+ImageUrlManager.h"

@implementation KuaiKanInfoModel

+(KuaiKanInfoModel *)toKuaiKanInfoModel:(NSDictionary *)dict
{
    [KuaiKanInfoModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id"};
    }];
    
    [Topic setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id",@"topic_description":@"description"};
    }];
    
    [KuaiKanInfoModel setupObjectClassInArray:^NSDictionary *{
        return @{@"topics":@"Topic"};
    }];
    
    KuaiKanInfoModel *kuaiKanModel = [KuaiKanInfoModel objectWithKeyValues:dict];
    
    [NSObject subFixObjectNeedReplaceIt:[NSMutableString stringWithString:kuaiKanModel.avatar_url] key:KEY_POINT_W];
    
    for (Topic *topic in kuaiKanModel.topics)
    {
        [Topic handleImageUrl:topic];
    }
    
    return kuaiKanModel;
}

@end
