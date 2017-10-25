//
//  RankListModel.h
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankListModel : NSObject

@property (nonatomic,copy)NSString *idd;

@property (nonatomic,assign)NSInteger collapse;

@property (nonatomic,copy)NSString *cover;

@property (nonatomic,copy)NSString *monthRank;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *totalRank;

+(NSArray *)toRankList:(NSArray *)ary;

@end
