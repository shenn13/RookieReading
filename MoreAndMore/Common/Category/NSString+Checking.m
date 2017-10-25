//
//  NSString+Checking.m
//  SanLianOrdering
//
//  Created by shiqichao on 14-10-22.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//

#import "NSString+Checking.h"

@implementation NSString (Checking)

//字符串判断是否为空
- (BOOL)checkEmpty{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ] isEqualToString:@""];
}

+(BOOL)checkEmpty:(NSString *)string
{
    return (string == nil || [string checkEmpty]);
}

//验证手机号码 合法为yes 
-(BOOL)checkMobileNumber
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

+ (BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];

    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    
    if (!isNum) {

        return NO;
        
    }
    int sumValue = 0;

    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];

    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

+(BOOL)checkMoneyValue:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers;
    NSRange pointRange = [textField.text rangeOfString:@"."];
    if ((pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length))
    {
        // 已经存在小数点之后不能输入小数点（切换扫描的数组)
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    else
    {
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    }
    
    // 首字母不能为.
    if ([textField.text isEqualToString:@""] && [string isEqualToString:@"."])
    {
        return NO;
    }
    
    short remain = 2; //默认保留2位小数
    NSString *tempStr = [textField.text stringByAppendingString:string];
    NSUInteger strlen = [tempStr length];
    NSLog(@"pointRange:%@",NSStringFromRange(pointRange));
    if(pointRange.length > 0 && pointRange.location > 0)
    {
        // 判断输入框内是否含有“.”。
        if([string isEqualToString:@"."]){
            // 当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
            return NO;
        }
        if(strlen > 0 && (strlen - pointRange.location) > remain+1)
        {
            //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
            return NO;
        }
    }
    
    NSRange zeroRange = [textField.text rangeOfString:@"0"];
    if(zeroRange.length == 1 && zeroRange.location == 0){
        // 判断输入框第一个字符是否为“0”
        if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1)
        {
            // 当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
            textField.text = string;
            return NO;
        }
        else
        {
            if(pointRange.length == 0 && pointRange.location > 0)
            {
                // 当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                if([string isEqualToString:@"0"]){
                    return NO;
                }
            }
        }
    }
    
    NSString *buffer;
    // 从scan中扫描出set中的数据放入value中(返回bool值）
    if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
    {
        return NO;
    }
    //NSLog(@"找到了:%@",buffer);
    
    return YES;
}

/*
 NSStringDrawingTruncatesLastVisibleLine：
 如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。
 如果没有指定NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略。
 
 NSStringDrawingUsesLineFragmentOrigin：
 绘制文本时使用 line fragement origin 而不是 baseline origin。
 
 NSStringDrawingUsesFontLeading：
 计算行高时使用行距。（注：字体大小+行间距=行距）
 
 NSStringDrawingUsesDeviceMetrics：
 计算布局时使用图元字形（而不是印刷字体）。
 */

//方法功能：计算字符串高度长度
- (CGSize)stringWidthWithFontSize:(CGFloat)fontSize andHeight:(CGFloat)height
{
    if ([UIDevice currentDevice].systemVersion.floatValue>7.0)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
        return [self boundingRectWithSize:CGSizeMake(320, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    }
    else
    {
        return [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(320, height)];
    }
}

//根据指定宽度，计算字符串高度
-(CGSize)stringHeightWithFontSize:(CGFloat)fontSize andWidth:(CGFloat)width
{
    if ([UIDevice currentDevice].systemVersion.floatValue>7.0)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
        return [self boundingRectWithSize:CGSizeMake(width, 3000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    }
    else
    {
        return [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, 3000)];
    }
}

-(NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end
