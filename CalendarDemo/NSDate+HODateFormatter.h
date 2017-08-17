//
//  NSDate+HODateFormatter.h
//  CalendarDemo
//
//  Created by VinceJee on 16/11/9.
//  Copyright © 2016年 VinceJee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HODateFormatter)

/**
 时
 */
- (NSUInteger)hour;

/**
 分
 */
- (NSUInteger)minute;

/**
 秒
 */
- (NSUInteger)second;

/**
 每日
 */
- (NSUInteger)day;

/**
 月
 */
- (NSUInteger)month;

/**
 年
 */
- (NSUInteger)year;

/**
 一年的第几周
 */
- (NSUInteger)week;

/**
 周几
 */
- (NSUInteger)weekday;

/**
 周几（汉语）
 */
- (NSString *)weekdayString;

/**
 月天数
 */
- (NSUInteger)monthCount;

/**
  一周第一天的日期
 */
- (NSString *)firstDayOfWeekWithDateFormatter:(NSString *)formatter;

/**
 一周最后一天的日期
 */
- (NSString *)lastDayOfWeekWithDateFormatter:(NSString *)formatter;

/** 
 上个月 包含年份
 */
- (NSString *)previousMonth;

/**
 下个月 包含年份
 */
- (NSString *)nextMonth;
 
/**
 前一天
 */
- (NSString *)nextDay;

/**
 后一天
 */
- (NSString *)previousDay;

/**
 一个月的第一个周一
 */
-(NSInteger)firstWeekDayInMonth;

/**
 日期转字符串
 */
+ (NSString *)dateTransferToStringWithDate:(NSDate *)date formatter:(NSString *)formatter;

/**
 字符串转日期
 */
+ (NSDate *)stringTransferToDateWithDateString:(NSString *)dateString formatter:(NSString *)formatter;

/**
 月份英文格式显示 
 是否简写
 */
+ (NSString *)monthTransferToEnglishFormatter:(NSString *)dateString simplifieEdition:(BOOL)simplifieEdition;

@end
