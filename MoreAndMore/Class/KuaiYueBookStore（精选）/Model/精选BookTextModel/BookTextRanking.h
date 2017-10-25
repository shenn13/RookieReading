//
//  BookTextRanking.h
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TextBook.h"

@interface BookTextRanking : NSObject

@property (nonatomic,assign)NSInteger __v;
@property (nonatomic,copy)NSString *idd;

@property (nonatomic,strong)NSMutableArray *books;

@property (nonatomic,assign)NSInteger collapse;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSString *created;
@property (nonatomic,copy)NSString *gender;
@property (nonatomic,copy)NSString *idd2;
@property (nonatomic,assign)NSInteger isSub;
@property (nonatomic,assign)NSInteger nnew;
@property (nonatomic,assign)NSInteger priority;
@property (nonatomic,copy)NSString *tag;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *updated;

+(BookTextRanking *)toBookTextRanking:(NSDictionary *)dict;

@end
