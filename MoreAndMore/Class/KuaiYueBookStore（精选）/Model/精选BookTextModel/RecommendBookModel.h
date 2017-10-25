//
//  RecommendBookModel.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendBookModel : NSObject

@property (nonatomic,copy)NSString *author;

@property (nonatomic,assign)NSInteger bookCount;

@property (nonatomic,assign)NSInteger collectorCount;

@property (nonatomic,copy)NSString *cover;

@property (nonatomic,copy)NSString *desc;

@property (nonatomic,copy)NSString *idd;

@property (nonatomic,copy)NSString *title;

+(NSArray *)toRecommendBookAry:(NSArray *)ary;

+(NSMutableArray *)toRecommendBookAry2:(NSArray *)ary;

@end
