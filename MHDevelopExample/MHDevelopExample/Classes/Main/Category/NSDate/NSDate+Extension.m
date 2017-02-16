//
//  NSDate+Extension.m
//  YBJY
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 YouBeiJiaYuan. All rights reserved.
//

#import "NSDate+Extension.h"


#define DATE_COMPONENTS (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear |  NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)


#define CURRENT_CALENDAR [NSCalendar currentCalendar]



@implementation NSDate (Extension)
/**
 *  是否为今天
 */
- (BOOL)mh_isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)mh_isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] mh_dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self mh_dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)mh_dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}


/**
 *  是否为今年
 */
- (BOOL)mh_isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}


// This hard codes the assumption that a week is 7 days
- (BOOL) mh_isSameWeekWithAnotherDate: (NSDate *)anotherDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:anotherDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfMonth != components2.weekOfMonth) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:anotherDate]) < MH_D_WEEK);
}

/**
 *  星期几
 */
- (NSString *)mh_weekDay
{
    NSArray *weekDays = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    
//    NSLog(@"NSCalendarUnitWeekday--  components.weekday = %zd  -- components.weekdayOrdinal = %zd  -- components.weekOfYear = %zd  -- components.weekOfMonth = %zd",components.weekday , components.weekdayOrdinal , components.weekOfYear , components.weekOfMonth);
    
    return weekDays[components.weekday - 1];
}



- (BOOL) mh_isThisWeek
{
    return [self mh_isSameWeekWithAnotherDate:[NSDate date]];
}


/**
 *  通过一个时间 固定的时间字符串 "2016/8/10 14:43:45" 返回时间
 *
 *  @param timestamp 固定的时间字符串 "2016/8/10 14:43:45"
 *
 *  @return 时间
 */
+ (instancetype)mh_dateWithTimestamp:(NSString *)timestamp
{
    return [[NSDateFormatter mh_defaultDateFormatter] dateFromString:timestamp];
}


/**
 *  返回固定的 当前时间 2016-8-10 14:43:45
 */
+ (NSString *)mh_currentTimestamp
{
    return [[NSDateFormatter mh_defaultDateFormatter] stringFromDate:[NSDate date]];
}

/**
 * 格式化日期描述
 */
- (NSString *)mh_formattedDateDescription
{
    NSDateFormatter *dateFormatter = nil;
    NSString *result = nil;
    
    if ([self mh_isThisYear])
    {
        // 今年
        if ([self mh_isToday]) {
            // 22:22
            dateFormatter = [NSDateFormatter mh_dateFormatterWithFormat:@"HH:mm"];
        }else if ([self mh_isYesterday]){
            // 昨天 22:22
            dateFormatter = [NSDateFormatter mh_dateFormatterWithFormat:@"昨天 HH:mm"];
        }else if ([self mh_isThisWeek]){
            // 星期二 22:22
            dateFormatter = [NSDateFormatter mh_dateFormatterWithFormat:[NSString stringWithFormat:@"%@ HH:mm" , [self mh_weekDay]]];
        }else{
            // 2016年08月18日 22:22
            dateFormatter = [NSDateFormatter mh_dateFormatterWithFormat:@"yyyy年MM月dd日 HH:mm"];
        }
        
    }else{
        // 非今年
        dateFormatter = [NSDateFormatter mh_dateFormatterWithFormat:@"yyyy年MM月dd日"];
    }
    
    result = [dateFormatter stringFromDate:self];
    
    return result;
}

/** 与当前时间的差距 */
- (NSDateComponents *)mh_deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

@end
