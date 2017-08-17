//
//  NSDate+HODateFormatter.m
//  CalendarDemo
//
//  Created by VinceJee on 16/11/9.
//  Copyright © 2016年 VinceJee. All rights reserved.
//

// 公历为准
// Gregorian

#import "NSDate+HODateFormatter.h"

static NSCalendar *calendar = nil;
static NSDateFormatter *dateFormatter = nil;

@implementation NSDate (HODateFormatter)

- (NSUInteger)hour {
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitHour fromDate:self];
    return component.hour;
}

- (NSUInteger)minute {
    
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitMinute fromDate:self];
    return component.minute;
}

- (NSUInteger)second {
    
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitSecond fromDate:self];
    return component.second;
}

- (NSUInteger)day {
    
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitDay fromDate:self];
    return component.day;
}

- (NSUInteger)month {
    
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitMonth fromDate:self];
    return component.month;
}

- (NSUInteger)year {
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitYear fromDate:self];
    return component.year;
}

- (NSUInteger)week{
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekOfYear fromDate:self];
    return component.weekOfYear;
}

- (NSUInteger)weekday {
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return component.weekday;
}

- (NSString *)weekdayString {
    
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSString *weekdayString = @"";
    switch (component.weekday) {
        case 1: weekdayString = NSLocalizedString(@"Sunday", @"周日"); break;
        case 2: weekdayString = NSLocalizedString(@"Monday", @"周一"); break;
        case 3: weekdayString = NSLocalizedString(@"Tuesday", @"周二"); break;
        case 4: weekdayString = NSLocalizedString(@"Wednesday", @"周三"); break;
        case 5: weekdayString = NSLocalizedString(@"Thursday", @"周四"); break;
        case 6: weekdayString = NSLocalizedString(@"Friday", @"周五"); break;
        case 7: weekdayString = NSLocalizedString(@"Saturday", @"周六"); break;
        default: break;
    }
    
    return weekdayString;
}

- (NSUInteger)monthCount {
    
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitMonth fromDate:self];
    
    switch (component.month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
        {
            return 31;
        }
            break;
        
        case 4:
        case 6:
        case 9:
        case 11:
        {
            return 30;
        }
            break;
        
        case 2:
        {
            if (component.isLeapMonth) {
                return 29;
            }else {
                return 28;
            }
        }
            break;
            
        default:
            break;
    }
    
    return component.weekday;
}

- (NSString *)firstDayOfWeekWithDateFormatter:(NSString *)formatter {
    
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekday fromDate:self];
    
    NSTimeInterval interval = -(component.weekday - 1) * 24 * 60 * 60;
    NSDate *firstDayDate = [self dateByAddingTimeInterval:interval];
    return [[self class] dateTransferToStringWithDate:firstDayDate formatter:formatter];
}

- (NSString *)lastDayOfWeekWithDateFormatter:(NSString *)formatter {
    
    if (!calendar) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekday fromDate:self];
    
    NSTimeInterval interval = (7 - component.weekday) * 24 * 60 * 60;
    NSDate *lastDayDate = [self dateByAddingTimeInterval:interval];
    
    return [[self class] dateTransferToStringWithDate:lastDayDate formatter:formatter];
}

- (NSString *)previousMonth {
    
    NSInteger currentMonth = [self month];
    NSInteger previousMonth = 0;
    NSInteger year = [self year];
    NSInteger previousYear = 0;
    
    if (currentMonth==1) {
        previousMonth = 12;
        previousYear = year - 1;
    }else {
        previousMonth = currentMonth -1;
        previousYear = year;
    }
    
    return [NSString stringWithFormat:@"%04zd.%02zd",previousYear,previousMonth];
}

- (NSString *)nextMonth {
    
    NSInteger currentMonth = [self month];
    NSInteger nextMonth = 0;
    NSInteger year = [self year];
    NSInteger nextYear = 0;
    
    if (currentMonth==12) {
        nextMonth = 1;
        nextYear = year + 1;
    }else {
        nextMonth = currentMonth + 1;
        nextYear = year;
    }
    
    return [NSString stringWithFormat:@"%04zd.%02zd",nextYear,nextMonth];
}


/**
 前一天
 */
- (NSString *)nextDay {
    
    NSInteger currentMonth = [self month];
    NSInteger currentYear = [self year];
    NSInteger currentDay = [self day];
    
    NSInteger monthCount = [self monthCount];
    
    NSInteger nextMonth = 0;
    NSInteger nextYear = 0;
    NSInteger nextDay = 0;
    
    if (currentDay == monthCount) {
        nextDay = 1;
        if (currentMonth == 12) {
            nextYear = currentYear + 1;
            nextMonth = 1;
        }
        else{
            nextYear = currentYear;
            nextMonth = currentMonth + 1;
        }
    }
    else{
        nextDay = currentDay + 1;
        nextMonth = currentMonth;
        nextYear = currentYear;
    }
    
    return [NSString stringWithFormat:@"%04zd.%02zd.%02zd", nextYear, nextMonth, nextDay];
}

/**
 后一天
 */
- (NSString *)previousDay {
    
    NSInteger currentMonth = [self month];
    NSInteger currentYear = [self year];
    NSInteger currentDay = [self day];
    
    NSInteger previousMonth = 0;
    NSInteger previousYear = 0;
    NSInteger previousDay = 0;
    
    if (currentDay == 1) {
        if (currentMonth == 1) {
            previousYear = currentYear - 1;
            previousMonth = 12;
        }
        else {
            previousMonth = currentMonth;
            previousYear = currentYear;
        }
        previousDay = [[NSDate stringTransferToDateWithDateString:[NSString stringWithFormat:@"%04zd.%02zd.01",previousYear, previousMonth] formatter:@"yyyy.MM.dd"] monthCount];
    }
    else {
        
        previousDay = currentDay - 1;
        previousMonth = currentMonth;
        previousYear = currentYear;
    }
    
    return [NSString stringWithFormat:@"%04zd.%02zd.%02zd", previousYear, previousMonth, previousDay];
}

+ (NSString *)dateTransferToStringWithDate:(NSDate *)date formatter:(NSString *)formatter {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)stringTransferToDateWithDateString:(NSString *)dateString formatter:(NSString *)formatter {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)monthTransferToEnglishFormatter:(NSString *)dateString simplifieEdition:(BOOL)simplifieEdition
{
    NSInteger number = [dateString integerValue];
    NSString *resultString = @"";
    if (simplifieEdition) {
        
        switch (number) {
            case 1: resultString = @"Jan"; break;
            case 2: resultString = @"Feb"; break;
            case 3: resultString = @"Mar"; break;
            case 4: resultString = @"Apr"; break;
            case 5: resultString = @"May"; break;
            case 6: resultString = @"Jun"; break;
            case 7: resultString = @"Jul"; break;
            case 8: resultString = @"Aug"; break;
            case 9: resultString = @"Sep"; break;
            case 10: resultString = @"Oct"; break;
            case 11: resultString = @"Nov"; break;
            case 12: resultString = @"Dec"; break;
                
            default:resultString = nil;
                break;
        }
    }
    else {
        
        switch (number) {
            case 1: resultString = @"January"; break;
            case 2: resultString = @"February"; break;
            case 3: resultString = @"March"; break;
            case 4: resultString = @"April"; break;
            case 5: resultString = @"May"; break;
            case 6: resultString = @"June"; break;
            case 7: resultString = @"July"; break;
            case 8: resultString = @"August"; break;
            case 9: resultString = @"September"; break;
            case 10: resultString = @"October"; break;
            case 11: resultString = @"November"; break;
            case 12: resultString = @"December"; break;
                
            default:resultString = nil;
                break;
        }
    }
    return resultString;
}

-(NSInteger)firstWeekDayInMonth {
    
    if (calendar == nil) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    [calendar setFirstWeekday:1];
    
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [calendar dateFromComponents:comps];
    
    return [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:newDate];
}

@end
