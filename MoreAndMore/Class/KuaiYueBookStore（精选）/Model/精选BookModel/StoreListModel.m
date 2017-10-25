//
//  StoreListModel.m
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "StoreListModel.h"

@implementation StoreListModel

+(NSArray *)toStoreListModel:(NSArray *)dataArr
{
    // User
    [User setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id"};
    }];
    
    // Topic
    [Topic setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id",@"topic_description":@"description"};
    }];
    
    // Banner
    [Banner setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id"};
    }];
    
    // StoreListModel
    [StoreListModel setupObjectClassInArray:^NSDictionary *{
        return @{@"topics":@"Topic",@"banners":@"Banner"};
    }];
    
    NSArray *storeLists = [StoreListModel objectArrayWithKeyValuesArray:dataArr];
    for (StoreListModel *listModel in storeLists)
    {
        for (Topic *topic in listModel.topics)
        {
            // V2版本idd为空
            if (topic.idd.length < 1 && topic.target_id.length > 0) {
                topic.idd = topic.target_id;
            }
        }
    }
    return storeLists;
}

+(NSMutableArray *)handleImageUrlIfNeed:(NSMutableArray *)dataArr
{
    for (StoreListModel *model in dataArr)
    {
        for (Topic *topic in model.topics)
        {
            [Topic handleImageUrl:topic];
        }
        
        for (Banner *banner in model.banners)
        {
            [Banner handleImageUrl:banner];
        }
    }
    return dataArr;
}

@end
