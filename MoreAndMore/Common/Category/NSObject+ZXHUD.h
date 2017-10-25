//
//  NSObject+ZXHUD.h
//  topLicaiPro
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ActivityHUDState){
    ActivityHUDStateFailed = 0,  // 加载失败
    ActivityHUDStateSuccess = 1,  // 加载成功
};

@interface NSObject (ZXHUD)

/**
 *  当展示菊花样式时：
    默认是加在KEY_WINDOW上，且用户不可操作。
    调用stopActivityWithText方法停止菊花。
 */

@property (nonatomic,retain)MBProgressHUD *HUD;

// 展示消息 (仅文本)
-(void)showText:(NSString *)text inView:(UIView *)view;

// 展示消息 (文本加图片)
-(void)showTextWithState:(ActivityHUDState)state inView:(UIView *)view text:(NSString *)text;

// 开始加载
-(void)startActivityWithText:(NSString *)text;
// 停止加载
- (void)stopActivityWithText:(NSString *)text state:(ActivityHUDState)state;

@end
