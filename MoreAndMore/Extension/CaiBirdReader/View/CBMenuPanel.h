//
//  CBMenuPanel.h
//  MoreAndMore
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CBMenuPanelActionType) {
    CBMenuPanelActionTypeClose,     // 关闭
    CBMenuPanelActionTypeMore,      // 顶部更多
    CBMenuPanelActionTypeLast,      // 上一章
    CBMenuPanelActionTypeNext,      // 下一章
    CBMenuPanelActionTypePageJump,  // 跳转进度
    CBMenuPanelActionTypeBgChange,  // 背景改变
    CBMenuPanelActionTypeFontChange,// 字体改变
    CBMenuPanelActionTypeExtLeftMenu, // 底部扩展<左>
    CBMenuPanelActionTypeExtRightMenu,// 底部扩展<右>
    CBMenuPanelActionTypeOther
};

@interface CBMenuPanel : UIView

// 跳转的章节
@property (nonatomic,assign,readonly)NSInteger jumpChalpterIndex;

// 当前是显示还是隐藏
@property (nonatomic,assign,readonly)BOOL show;

@property (nonatomic,copy)void(^CBMenuPanleAction)(CBMenuPanelActionType actionType);

-(void)showPanelMenu:(BOOL)animated;
-(void)hiddenPanelMenu:(BOOL)animated;

// 更新阅读进度
-(void)updateReaderPanelWithChalpters:(NSInteger)chalpterCount readerChalpter:(NSInteger)readerChalpter;

@end
