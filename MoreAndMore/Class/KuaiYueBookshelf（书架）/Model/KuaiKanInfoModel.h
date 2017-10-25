//
//  KuaiKanInfoModel.h
//  MoreAndMore
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"

@interface KuaiKanInfoModel : NSObject

@property (nonatomic,copy)NSString *avatar_url;
@property (nonatomic,assign)NSInteger follower_cnt;
@property (nonatomic,assign)NSInteger following;
@property (nonatomic,assign)NSInteger grade;
@property (nonatomic,copy)NSString *idd;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,assign)NSInteger pub_feed;
@property (nonatomic,copy)NSString *reg_type;
@property (nonatomic,assign)NSInteger reply_remind_flag;
@property (nonatomic,copy)NSString *u_intro;
@property (nonatomic,assign)NSInteger update_remind_flag;

@property (nonatomic,strong)NSMutableArray *topics;

+(KuaiKanInfoModel *)toKuaiKanInfoModel:(NSDictionary *)dict;

@end
