//
//  BookReviewModel.h
//  MoreAndMore
//
//  Created by apple on 16/10/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReviewBook.h"

@class TextBook;
@interface BookReviewModel : NSObject

@property (nonatomic,copy)NSString *idd;

@property (nonatomic,strong)ReviewBook *book;

@property (nonatomic,copy)NSString *created;

/*
 helpful =     {
    no = 24;
    total = 24;
    yes = 48;
 };
 */
@property (nonatomic,strong)NSDictionary *helpful;

@property (nonatomic,assign)NSInteger likeCount;

@property (nonatomic,copy)NSString *normal;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *updated;

+(NSMutableArray *)toBookReviewModelAry:(NSArray *)ary;

-(TextBook *)toTextBook;
 
@end
