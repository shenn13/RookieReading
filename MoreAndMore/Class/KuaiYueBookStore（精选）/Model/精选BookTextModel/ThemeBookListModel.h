//
//  ThemeBookListModel.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TextAuthor.h"
#import "ThemeBookModel.h"

/**
 *  主题书单数据模型
 */

@interface ThemeBookListModel : NSObject

@property (nonatomic,assign)NSInteger isDistillate;

@property (nonatomic,copy)NSString *shareLink;

@property (nonatomic,copy)NSString *idd;

@property (nonatomic,copy)NSString *updated;

@property (nonatomic,copy)NSString *created;

@property (nonatomic,assign)NSInteger collectorCount;
// male
@property (nonatomic,copy)NSString *gender;

@property (nonatomic,strong)TextAuthor *author;

@property (nonatomic,strong)NSArray *tags;

// _id
@property (nonatomic,copy)NSString *idd2;

@property (nonatomic,copy)NSString *desc;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *stickStopTime;

@property (nonatomic,assign)NSInteger isDraft;

// 里面是ThemeBookModel对象
@property (nonatomic,strong)NSMutableArray *books;

+(ThemeBookListModel *)toThemeBookListModel:(NSDictionary *)dict;

@end
