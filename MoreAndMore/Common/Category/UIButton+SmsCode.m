//
//  UIButton+SmsCode.m
//  schoolfriends
//
//  Created by Silence on 16/4/25.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "UIButton+SmsCode.h"

@implementation UIButton (SmsCode)

#pragma mark “获取验证码”按钮标题倒计时

-(void)startTimeWithButtonTime:(int)time
{
    __block int timeout= time; //倒计时时间
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor lightGrayColor];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.backgroundColor = [UIColor colorWithRed:41.f/255.f green:147.f/255.f blue:244.f/255.f alpha:1];
                self.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self setTitle:[NSString stringWithFormat:@"%zd秒后重试",timeout] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
