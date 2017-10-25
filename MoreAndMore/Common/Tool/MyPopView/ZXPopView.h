//
//  ZXPopView.h
//  schoolfriends
//
//  Created by Silence on 16/3/11.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

// 三角形所在的位置  默认为 右
typedef NS_ENUM(NSInteger , TrianglePosition){
    TrianglePositionOfLeft,
    TrianglePositionOfMiddle,
    TrianglePositionOfRight
};

@interface ZXPopView : UIView

/**
 *  创建一个弹出下拉控件
 *
 *  @param origin     表格右上角的point所在的位置
 *  @param dataSource 选择控件的数据源
 *  @param action     点击回调方法
 *  @param animation   是否动画弹出
 */
+(void)showPopViewWithWindowOrigin:(CGPoint)origin dataSource:(NSArray *)dataSource icons:(NSArray *)icons action:(void (^)(NSInteger idx))action position:(TrianglePosition)position width:(CGFloat)width showSelect:(BOOL)showSel defaultIdx:(NSInteger)defaultIdx animation:(BOOL)animation;

@end
