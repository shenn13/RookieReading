//
//  ChalpterTextListModel.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChalpterTextModel.h"

@interface ChalpterTextListModel : NSObject

@property (nonatomic,copy)NSString *host;

@property (nonatomic,copy)NSString *idd;

@property (nonatomic,copy)NSString *updated;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,strong)NSMutableArray *chapters;

@property (nonatomic,copy)NSString *link;

+(ChalpterTextListModel *)toChalpterListModel:(NSDictionary *)dict;

@end
