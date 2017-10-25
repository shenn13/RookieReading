//
//  ZXMenuListView.h
//  topLicaiPro
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXMenuListViewDelegate <NSObject>

-(void)resultListViewDidSelectRow:(NSInteger)index;

-(void)cancelListView;

@end

@interface ZXMenuListView : UIView

@property (nonatomic,weak)id<ZXMenuListViewDelegate> delegate;

/**
 *  从哪里开始出现菜单列表 Y （在window中的坐标）
 */
+(ZXMenuListView *)menuWithTitleAry:(NSArray *)ary index:(NSInteger)index;

/**
 *  显示、隐藏
 */
-(void)showOrHiidenMenuView:(BOOL)isHidden offsetY:(CGFloat)Y;

@end
