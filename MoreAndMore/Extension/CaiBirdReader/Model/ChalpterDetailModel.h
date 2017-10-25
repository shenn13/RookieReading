//
//  ChalpterDetailModel.h
//  MoreAndMore
//
//  Created by apple on 2017/2/27.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChalpterDetailModel : NSObject

@property (nonatomic,assign)NSString *body;

@property (nonatomic,copy)NSString *cpContent;

@property (nonatomic,assign)NSInteger currency;

@property (nonatomic,copy)NSString *idd;

@property (nonatomic,assign)NSInteger isVip;

@property (nonatomic,copy)NSString *title;

+(ChalpterDetailModel *)toChalpterDetailModel:(NSDictionary *)dict;

@end
