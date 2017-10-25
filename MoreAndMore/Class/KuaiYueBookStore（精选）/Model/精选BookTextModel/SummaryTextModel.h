//
//  SummaryTextModel.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SummaryTextModel : NSObject

@property (nonatomic,copy)NSString *idd;

@property (nonatomic,assign)NSInteger chaptersCount;

@property (nonatomic,copy)NSString *host;

@property (nonatomic,assign)NSInteger isCharge;

@property (nonatomic,copy)NSString *lastChapter;

@property (nonatomic,copy)NSString *link;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *source;

@property (nonatomic,assign)NSInteger starting;

@property (nonatomic,copy)NSString *updated;

+(NSArray *)toSummaryModelAry:(NSArray *)ary;

@end
