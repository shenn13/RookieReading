//
//  BookComicDetail.m
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookComicDetail.h"

@implementation BookComicDetail

+(BookComicDetail *)toBookComicDetail:(NSDictionary *)dict
{
    [BookComicDetail setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id"};
    }];
    
    [BookComicDetail setupObjectClassInArray:^NSDictionary *{
        return @{@"image_infos":@"ComicImageInfo"};
    }];
    
    [Topic setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id",@"topic_description":@"description"};
    }];
    
    BookComicDetail *comicDetail = [BookComicDetail objectWithKeyValues:dict];
    
    for (ComicImageInfo *info in comicDetail.image_infos)
    {
        // 默认霸占全屏
        info.scaleHeight = SCREEN_WIDTH/(info.width/info.height);
    }
    
    return comicDetail;
}

@end
