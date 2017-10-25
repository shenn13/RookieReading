//
//  NSString+DateUtil.m
//  schoolfriends
//
//  Created by Silence on 16/3/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "NSString+DateUtil.h"

@implementation NSString (DateUtil)

// timeInterval转字符串
+(NSString *)timeIntervalToString:(NSTimeInterval)interval formatter:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000.f];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    dateFormatter.dateFormat = format;
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

// 格式字符串转时间
+(NSDate *)stringToDateWithFromat:(NSString *)format string:(NSString *)dateStr
{
    NSDateFormatter *theFormat = [[NSDateFormatter alloc] init];
    theFormat.dateFormat = format;
    [theFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    NSDate *date = [theFormat dateFromString:dateStr];
    return date;
}

// 时间转字符串
+(NSString *)dateToStringWithFormat:(NSString *)format date:(NSDate *)date
{
    NSDateFormatter *theFormat = [[NSDateFormatter alloc] init];
    theFormat.dateFormat = format;
    [theFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    NSString *dateStr = [theFormat stringFromDate:date];
    return dateStr;
}

// 时间转星期
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate
{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

// 时间字符串转时间描述字符串（例：3小时以前)
+(NSString *)timeStringToTimeDescription:(NSString *)str
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) < 5){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else{
        result = str;
    }
    
    return result;
    
    /**
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
     */
}

/** 秒数转时间描述字符串 */
+(NSString *)timeIntervalToTimeDescription:(NSInteger)timeInterval format:(NSString *)format
{
    // 获取当前时时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 时间差
    NSTimeInterval time = currentTime - timeInterval/1000.f;
    
    if (time < 60) {
        return [NSString stringWithFormat:@"刚刚"];
    }
    
    NSInteger minutes = time/60;
    if (minutes<60) {
        return [NSString stringWithFormat:@"%ld分钟前",minutes];
    }
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 5) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }

    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
    
    //return [NSString dateToStringWithFormat:format date:date];
}

+(NSString *)timeIntervalToAge:(NSDate *)date
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return [NSString stringWithFormat:@"%ld岁",iAge];
}

@end
