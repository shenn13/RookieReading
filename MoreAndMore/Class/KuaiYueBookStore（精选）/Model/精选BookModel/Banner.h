//
//  Banner.h
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * 官方活动：type = 3
 */

@interface Banner : NSObject

/*!
 * 转换：id -> idd
 */
@property (nonatomic,copy)NSString *idd;

@property (nonatomic,copy)NSString *pic;

@property (nonatomic,copy)NSString *target_id;

@property (nonatomic,copy)NSString *target_title;

@property (nonatomic,assign)int type;

/**
 *  V2新增
 */
@property (nonatomic,copy)NSString *target_package_name;
@property (nonatomic,copy)NSString *good_alias;
@property (nonatomic,copy)NSString *good_price;
@property (nonatomic,copy)NSString *target_app_url;
@property (nonatomic,copy)NSString *target_web_url;


+(Banner *)handleImageUrl:(Banner *)banner;

@end
