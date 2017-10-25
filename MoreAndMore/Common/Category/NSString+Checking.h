//
//  NSString+Checking.h
//  SanLianOrdering
//
//  Created by shiqichao on 14-10-22.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Checking)

#pragma mark 字符串检查相关
/*!
 * 字符串判断是否为空
 */
- (BOOL)checkEmpty;

+ (BOOL)checkEmpty:(NSString *)string;

/**
 * 验证手机号码
 */
-(BOOL)checkMobileNumber;

/**
 *  检测邮箱是否合法
 */
- (BOOL)isValidateEmail;

/*!
 * 检查输入的金额是否合法(最多两位小数)
 * @param 置于UITextFieldDelegate中
 */
+(BOOL)checkMoneyValue:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/*!
 * 检查输入的是否是合法的身份证号
 */
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo;

#pragma mark --长度宽度相关方法
//获得UILabel在设置text后的真实长度
-(CGSize)stringWidthWithFontSize:(CGFloat)fontSize andHeight:(CGFloat)height;

//根据指定宽度，计算Label高度
-(CGSize)stringHeightWithFontSize:(CGFloat)fontSize andWidth:(CGFloat)width;

// 去除字符串中的空格
-(NSString *)trim;

@end
