//
//  UIButton+SmsCode.h
//  schoolfriends
//
//  Created by Silence on 16/4/25.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SmsCode)

/*!
 * 开始获取验证码倒计时
 */
-(void)startTimeWithButtonTime:(int)time;

@end
