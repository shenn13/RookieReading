//
//  BookDetail.h
//  MoreAndMore
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "BookComic.h"

@interface BookDetail : NSObject

@property (nonatomic,copy)NSString *cover_image_url;
@property (nonatomic,copy)NSString *discover_image_url;
@property (nonatomic,copy)NSString *vertical_image_url;
@property (nonatomic,copy)NSString *title;

@property (nonatomic,assign)NSInteger comments_count;
@property (nonatomic,assign)NSInteger comics_count;
@property (nonatomic,assign)NSInteger fav_count;
@property (nonatomic,assign)NSString *likes_count;

@property (nonatomic,assign)NSInteger sort;
@property (nonatomic,assign)BOOL is_favourite;
@property (nonatomic,assign)NSInteger order;

@property (nonatomic,copy)NSString *created_at;
@property (nonatomic,assign)NSInteger updated_at;
@property (nonatomic,assign)NSInteger label_id;

//  description -> ddescription
@property (nonatomic,copy)NSString *ddescription;
//  id -> idd
@property (nonatomic,assign)NSInteger idd;

/*!
 * 里面是BookComic对象
 */
@property (nonatomic,strong)NSMutableArray *comics;
/*!
 * user对象
 */
@property (nonatomic,strong)User *user;

+(BookDetail *)toBookDetailModel:(NSDictionary *)dataDic;

@end
