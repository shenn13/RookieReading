//
//  ThemeBookListModel.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ThemeBookListModel.h"

@implementation ThemeBookListModel

+(ThemeBookListModel *)toThemeBookListModel:(NSDictionary *)dict
{
    [TextAuthor setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    [TextBook setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    [ThemeBookListModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id",@"idd2":@"_id"};
    }];
    
    [ThemeBookListModel setupObjectClassInArray:^NSDictionary *{
        return @{@"books":@"ThemeBookModel"};
    }];
    
    return [ThemeBookListModel objectWithKeyValues:dict];
}

@end
