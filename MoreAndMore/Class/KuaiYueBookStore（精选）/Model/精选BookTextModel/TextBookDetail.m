//
//  TextBookDetail.m
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "TextBookDetail.h"

#import "TextBook.h"

@implementation TextBookDetail

+(TextBookDetail *)toTextBookDetail:(NSDictionary *)dict
{
    [TextBookDetail setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id",@"le":@"_le"};
    }];
    
    TextBookDetail *detail = [TextBookDetail objectWithKeyValues:dict];
    
    /**
     *  检查是否已经收藏
     */
    Magic_BookText *magic = [[Magic_BookText MR_findByAttribute:@"idd" withValue:detail.idd] lastObject];
    if (magic) {
        detail.isCollect = YES;
    }else{
        detail.isCollect = NO;
    }
    return detail;
}

@end
