//
//  User.h
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

/*!
 * id -> idd
 */
@property (nonatomic,copy)NSString *idd;
// 作者、转发、分享 "reg_type" = author;
@property (nonatomic,copy)NSString *reg_type;

@property (nonatomic,copy)NSString *avatar_url;
@property (nonatomic,assign)NSInteger grade;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,assign)int pub_feed;


@end
