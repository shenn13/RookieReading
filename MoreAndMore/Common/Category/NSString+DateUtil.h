//
//  NSString+DateUtil.h
//  schoolfriends
//
//  Created by Silence on 16/3/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

// EEE 表示“周几”  EEEE 表示“星期几”
#define FORMAT_ONE      @"yyyy-MM-dd HH:mm"
#define FORMAT_TWO      @"yyyy年M月d日"
#define FORMAT_THREE    @"yyyy-MM-dd HH:mm:ss"
#define FORMAT_FOUR     @"yyyy-MM-dd EEEE HH:mm"

#define FORMAT_ZHUISHU  @"yyyy-MM-dd HH:mm:ss:fff"

@interface NSString (DateUtil)

// TimeInterval转字符串
+(NSString *)timeIntervalToString:(NSTimeInterval)interval formatter:(NSString *)format;

// 字符串转时间
+(NSDate *)stringToDateWithFromat:(NSString *)format string:(NSString *)dateStr;

// 时间转字符串
+(NSString *)dateToStringWithFormat:(NSString *)format date:(NSDate *)date;

// 时间转星期
+(NSString*)weekdayStringFromDate:(NSDate*)inputDate;

// 时间字符串转时间描述字符串（例：3小时以前)
+(NSString *)timeStringToTimeDescription:(NSString *)str;

// 秒数转时间描述字符串
+(NSString *)timeIntervalToTimeDescription:(NSInteger)timeInterval format:(NSString *)format;

// 时间戳转年龄
+(NSString *)timeIntervalToAge:(NSDate *)date;

@end
