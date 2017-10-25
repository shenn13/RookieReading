//
//  BookReaderController.h
//  MoreAndMore
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseTableViewController.h"

@interface BookReaderController : ZXBaseTableViewController

@property (nonatomic,copy)NSString *comicId;

/**
 *  从图书详情列表页面进入
 */
-(instancetype)initWithComicId:(NSString *)comicId;

@end
