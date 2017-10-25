//
//  ThemeBookModel.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TextBook.h"

@interface ThemeBookModel : NSObject

@property (nonatomic,strong)TextBook *book;

@property (nonatomic,copy)NSString *comment;

@end
