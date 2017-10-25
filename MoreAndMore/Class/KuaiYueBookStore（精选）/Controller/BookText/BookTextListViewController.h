//
//  BookTextListViewController.h
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseTableViewController.h"
#import "SummaryTextModel.h"

typedef NS_ENUM(NSInteger,BookTextListType){
    BookTextListTypeOfSummary = 0,  // 书籍来源列表
    BookTextListTypeOfChalpter  // 章节列表
};

@interface BookTextListViewController : ZXBaseTableViewController

@property (nonatomic,assign)BookTextListType type;

/**
 *  用于查询书源列表
 */
@property (nonatomic,copy)NSString *textBookId;

/**
 *  用于查询章节列表
 */
@property (nonatomic,strong)SummaryTextModel *summaryModel;

/**
 *  当前选中的书源、章节
 */
@property (nonatomic,assign)NSInteger selIndex;

@end
