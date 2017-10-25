//
//  StoreListModel.h
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"
#import "Banner.h"

@interface StoreListModel : NSObject

@property (nonatomic,copy)NSString *action;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,assign)int type;
/*!
 * 里面是Topic对象
 */
@property (nonatomic,strong)NSMutableArray *topics;
/*!
 * 里面是Banner对象
 */
@property (nonatomic,strong)NSMutableArray *banners;

/**
 *  V2新增 字段
 */

@property (nonatomic,assign)NSInteger more_flag;
@property (nonatomic,assign)NSInteger item_type;
@property (nonatomic,assign)NSInteger action_type;

/*
 V1
 轮播图：item_type = 1; action_type = 0;
 人气飙升：type = 4; action_type = 0;
 每周排行：type = 2; action_type = 0;
 新作出炉：type = 9; action_type = 10;
 主编力推：type = 7; action_type = 10;
 官方活动：item_type = 6; action_type = 10;

 V2
 每周点击排行榜：item_type = 2; action_type = 10;
 新作出炉：item_type = 5; action_type = 10;
 人气飙升：item_type = 4; action_type = 10;
 主编力推：item_type = 7; action_type = 10;
 1分钟轻松短漫：item_type = 5; action_type = 10;
 少年热血：item_type = 4; action_type = 10;
 少女纯爱：item_type = 7; action_type = 10;
 官方活动：item_type = 6; action_type = 0;
 绝美古风：item_type = 5; action_type = 10;
 烧脑怪谈：item_type = 4; action_type = 10;
 轻松爆笑：item_type = 7; action_type = 10;
 完结佳作：item_type = 5; action_type = 10;

 */

+(NSArray *)toStoreListModel:(NSArray *)dataArr;

+(NSMutableArray *)handleImageUrlIfNeed:(NSMutableArray *)dataArr;

@end
