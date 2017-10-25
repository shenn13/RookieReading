//
//  BookDetail.m
//  MoreAndMore
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookDetail.h"
#import "NSObject+ImageUrlManager.h"

@implementation BookDetail

+(BookDetail *)toBookDetailModel:(NSDictionary *)dataDic;
{
    // User
    [User setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id"};
    }];
    
    // Topic
    [BookComic setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id"};
    }];
    
    // BookDetail
    [BookDetail setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id",@"ddescription":@"description"};
    }];
    
    [BookDetail setupObjectClassInArray:^NSDictionary *{
        return @{@"comics":@"BookComic"};
    }];

    BookDetail *detail = [BookDetail objectWithKeyValues:dataDic];
    
    detail.cover_image_url = [BookDetail imageUrlIfNeedExtension:detail.cover_image_url extension:PIC_EXTENSION];
    detail.discover_image_url = [BookDetail imageUrlIfNeedExtension:detail.discover_image_url extension:PIC_EXTENSION];
    detail.vertical_image_url = [BookDetail imageUrlIfNeedExtension:detail.vertical_image_url extension:PIC_EXTENSION];
    
    return detail;
}


@end
