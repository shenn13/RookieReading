//
//  BookComic.h
//  MoreAndMore
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookComic : NSObject

@property (nonatomic,assign)NSInteger comments_count;

@property (nonatomic,copy)NSString *cover_image_url;

@property (nonatomic,assign)NSInteger created_at;

@property (nonatomic,assign)NSString *idd;

@property (nonatomic,assign)NSInteger likes_count;

@property (nonatomic,assign)NSInteger push_flag;

@property (nonatomic,copy)NSString *status;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,assign)NSInteger topic_id;

@property (nonatomic,assign)NSInteger updated_at;

@property (nonatomic,copy)NSString *url;

@end
