//
//  AdvertModel.h
//  MoreAndMore
//
//  Created by Silence on 16/6/6.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertModel : NSObject

@property (nonatomic,copy)NSString *pic,*title,*value;

@property (nonatomic,assign)int type;

+(NSArray *)advertArrWithDataArr:(NSArray *)arr;

+(NSMutableArray *)handleImageUrlIfNeed:(NSMutableArray *)dataArr;

@end
