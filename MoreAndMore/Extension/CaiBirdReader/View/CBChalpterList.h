//
//  CBChalpterList.h
//  MoreAndMore
//
//  Created by apple on 2017/2/27.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryTextModel.h"
#import "ChalpterTextListModel.h"
#import "ChalpterDetailModel.h"

typedef NS_ENUM(NSInteger,ChalpterListType) {
    ChalpterListTypeChalpter = 0,    // 目录
    ChalpterListTypeSource           // 书籍源
};

@interface CBChalpterList : UIView<UITableViewDataSource,UITableViewDelegate>

// 书籍ID
@property (nonatomic,copy)NSString *textBookId;

// 书籍源<索引>
@property (nonatomic,assign)NSInteger summaryIndex;
// 章节<索引>
@property (nonatomic,assign)NSInteger chalpterIndex;
// 列表展示类型<0:目录   1:换源>
@property (nonatomic,assign)ChalpterListType listType;

// 书籍源列表<数据模型>
@property (nonatomic,strong)NSArray<SummaryTextModel *> *summaryAry;
// 章节列表<数据模型>
@property (nonatomic,strong)ChalpterTextListModel *chalpterList;
// 选择的源
@property (nonatomic,strong)SummaryTextModel *summaryModel;
// 选择的章节源
@property (nonatomic,strong)ChalpterTextModel *chalperModel;

// 章节详情获取成功回调Block
@property (nonatomic,copy)void(^ChalpterLoadCompletion)(ChalpterDetailModel *model);

// 加载数据
-(void)loadDataWithBookID:(NSString *)textBookId;

// 获取章节<文本数据>
-(void)loadChalpterDetailText:(ChalpterTextModel *)textModel;
// 上一章<-1>、下一章<+1>
-(void)loadChalpterDetailWithNewChalpter:(NSInteger)chalpter;

// 显示/隐藏
-(void)showChalpterListView:(BOOL)animated;
-(void)hiddenChalpterListView:(BOOL)animated;

@end
