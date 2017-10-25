//
//  BookComicDetail.h
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Topic.h"
#import "ComicImageInfo.h"

@interface BookComicDetail : NSObject

// 里面放的ImageInfo对象：height + width属性
@property (nonatomic,strong)NSMutableArray *image_infos;

@property (nonatomic,copy)NSString *idd;

// 下一章节ID（注意排序）
@property (nonatomic,copy)NSString *next_comic_id;
// 上一章节ID
@property (nonatomic,copy)NSString *previous_comic_id;

@property (nonatomic,strong)NSMutableArray *images;

@property (nonatomic,strong)NSDictionary *banner_info;

@property (nonatomic,copy)NSString *status; // published  （猜测应该还有几种是官方、收费）

@property (nonatomic,copy)NSString *url;

@property (nonatomic,assign)BOOL is_favourite;
@property (nonatomic,assign)BOOL is_liked;

@property (nonatomic,copy)NSString *cover_image_url;
@property (nonatomic,copy)NSString *created_at;

@property (nonatomic,assign)NSInteger likes_count;
@property (nonatomic,assign)NSInteger comments_count;

@property (nonatomic,assign)NSInteger push_flag;

@property (nonatomic,assign)NSInteger recommend_count;
@property (nonatomic,assign)NSInteger serial_no;
@property (nonatomic,assign)NSInteger storyboard_cnt;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,strong)Topic *topic;

+(BookComicDetail *)toBookComicDetail:(NSDictionary *)dict;

@end
