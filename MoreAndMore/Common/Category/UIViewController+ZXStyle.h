//
//  UIViewController+ZXStyle.h
//  MoreAndMore
//
//  Created by Silence on 16/6/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BarItemPosition){
    BarItemPositionOfLeft,  // 左边
    BarItemPositionOfRight  // 右边
};

typedef NS_ENUM(NSInteger,AppApiType){
    AppApiTypeOfKuaiKan,
    AppApiTypeOfZhuiShu
};

#define ITEM_FONTSIZE   16
#define ITEM_TAG        888

@interface UIViewController (ZXStyle)

#pragma mark 导航栏BarItem配置
/*!
 * 控制BarItem距离左右两边的距离
 * @param offset  默认距离为0, -10为紧凑
 */
+(UIBarButtonItem *)getNegativeSpacer:(CGFloat)offSet;

/*!
 * 配置BarItem风格（只有图片、只有标题、图片+标题）
 * @param norTitle      "未选中状态"标题
 * @param selTitle      "选中状态"标题
 * @param imageName     "未选中状态"图片
 * @param selImageName  "选中状态"图片
 * @param tag           给barItem里面的UIButton绑定的tag（只有一个时可传）
 */
+(UIBarButtonItem *)barItemWithTarget:(id)target action:(SEL)action tag:(NSInteger)tag norTitle:(NSString *)norTitle selTitle:(NSString *)selTitle imageName:(NSString *)imageName selImageName:(NSString *)selImageName;

/*!
 * BarItem风格（图片/标题数组）
 */
-(void)barItemWithPosition:(BarItemPosition)position isImage:(BOOL)isImage spacer:(CGFloat)spacer norArr:(NSArray *)norArr selArr:(NSArray *)selArr;

#pragma mark 导航栏按钮点击事件
-(void)leftBarItemClick:(UIButton *)leftItem;

-(void)rightBarItemClick:(UIButton *)rightItem;

-(void)dismissOrPopBack;

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view;

@end
