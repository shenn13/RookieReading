//
//  CBPaging.h
//  MoreAndMore
//
//  Created by apple on 2017/2/28.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChalpterDetailModel.h"

@interface CBPaging : NSObject

@property (nonatomic,strong)ChalpterDetailModel *chapter;

@property (nonatomic,assign)CGRect textRenderRect;

// 当前正在阅读的页面
@property (nonatomic,assign)NSUInteger readerPage;

-(instancetype)initWithChalpter:(ChalpterDetailModel *)chalpter;

/**
 *  分页
 */
- (void)paginate;

/**
 *  一共分了多少页
 */
- (NSUInteger)pageCount;

/**
 *  获得page页的文字内容
 */
- (NSString *)stringOfPage:(NSUInteger)page;

/**
 *  根据当前的页码计算范围 - 目的是为了变字号的时候内容偏移不要太多
 */
- (NSRange)rangeOfPage:(NSUInteger)page;

@end
