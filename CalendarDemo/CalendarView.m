//
//  CalendarView.m
//  CalendarDemo
//
//  Created by VinceJee on 2017/8/7.
//  Copyright © 2017年 VinceJee. All rights reserved.
//

#import "CalendarView.h"
#import "NSDate+HODateFormatter.h"

#define kCalendarW UIScreen.mainScreen.bounds.size.width
#define kCalendarEleW (UIScreen.mainScreen.bounds.size.width/7)
#define kCalendarEleH 50
#define kMenstrualPeriod 5.0

static NSString *formatter = @"yyyy.M";

@implementation CalendarView {
    
    NSDate *_changeDate; // 日期[用来计算上月下月]
    NSDate *_currDate;
    CGContextRef _context;
    CGFloat _menstrualH;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currDate = [NSDate date];
        _changeDate = _currDate;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, [self menstrualPeriodHeight]);
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    _context = UIGraphicsGetCurrentContext();
    CGContextClearRect(_context, rect);
    CGContextSetFillColorWithColor(_context, [UIColor whiteColor].CGColor);
    CGContextFillRect(_context, rect);
    
    [self drawLines];
    [self drawNumbers:_changeDate];
}

#pragma mark - menstrual height
- (CGFloat)menstrualPeriodHeight {
    NSInteger rowCount = [self calculateRowCount];
    _menstrualH = (rowCount - 1) * kCalendarEleH;
    return _menstrualH;
}

#pragma mark - title
- (NSString *)titleLabelStr {
    return [NSDate dateTransferToStringWithDate:_changeDate formatter:formatter];
}

#pragma mark - frame
- (void)updateFrame {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self menstrualPeriodHeight]);
}

#pragma mark - previous
- (void)previousMonth {
    
    NSInteger count = -[_changeDate monthCount];
    
    NSDate *proviousDate = [_changeDate dateByAddingTimeInterval:count*24*60*60];
    _changeDate = proviousDate;
    
    [self updateFrame];
    [self setNeedsDisplay];
}

#pragma mark - next
- (void)nextMonth {

    NSDate *nextDate = [_changeDate dateByAddingTimeInterval:[_changeDate monthCount]*24*60*60];
    _changeDate = nextDate;
    
    [self updateFrame];
    [self setNeedsDisplay];
}

#pragma mark - today
- (void)backToToday {
    _changeDate = _currDate;
    [self updateFrame];
    [self setNeedsDisplay];
}

#pragma mark - months
- (void)drawNumbers:(NSDate *)date {
    
    NSInteger firstWeekday = [date firstWeekDayInMonth]-1;
    
    NSInteger monthCount = [date monthCount] + firstWeekday;
    
    NSInteger columnCount = 7;
    NSInteger rowCount = monthCount / columnCount + 1;
    NSInteger index = 0;
    
    for (NSInteger r=0; r<rowCount; r++) {
        for (NSInteger c=0; c<columnCount; c++) {
            
            CGFloat x = kCalendarEleW * c;;
            CGFloat y = kCalendarEleH * r;
            
            ++ index;
            NSString *str = [NSString stringWithFormat:@"%@",@(index-firstWeekday)];
            
            if (index-firstWeekday <= 0 || index > monthCount) {
                continue;
            }
            
            CGRect frame = CGRectMake(x+0.3, y+12, kCalendarEleW, kCalendarEleH);
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.alignment = NSTextAlignmentCenter;
            
            [str drawInRect:frame withAttributes:@{
                                                   NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                   NSForegroundColorAttributeName:[UIColor blackColor],
                                                   NSParagraphStyleAttributeName:style
                                                   }];
 #pragma mark - lines color
            if ([_changeDate year] == [_currDate year] && [_changeDate month] == [_currDate month] && [str integerValue] == [_currDate day])
                    CGContextSetStrokeColorWithColor(_context, kTodaycolor.CGColor);
            else
                CGContextSetStrokeColorWithColor(_context, [[UIColor orangeColor] colorWithAlphaComponent:0.3].CGColor);
            
            CGContextSetLineWidth(_context, kMenstrualPeriod);
            
            CGPoint from = CGPointMake(x, y+kCalendarEleH-kMenstrualPeriod*0.5+0.5);
            CGPoint to = CGPointMake(x+kCalendarEleW, y+kCalendarEleH-kMenstrualPeriod*0.5+0.5);
            [self lineContext:_context fromPoint:from toPoint:to];
        }
    }
}

#pragma mark - lines

- (NSInteger)calculateRowCount {
    NSInteger monthCount = [_changeDate monthCount] + [_changeDate firstWeekDayInMonth]-1;
    
    NSInteger columnCount = 7;
    NSInteger rowCount = monthCount / columnCount + 1;
    if (monthCount % 7 != 0) {
        rowCount += 1;
    }
    return rowCount;
}

- (void)drawLines {
    
    NSInteger rowCount = [self calculateRowCount];
    NSInteger columnCount = 7;
    
    CGContextSetStrokeColorWithColor(_context, [[UIColor grayColor] colorWithAlphaComponent:0.3].CGColor);
    
    for (NSInteger i = 0; i < rowCount; i ++) {
        CGPoint fromRow = CGPointMake(0, kCalendarEleH * i);
        CGPoint toRow = CGPointMake(kCalendarW, kCalendarEleH * i);
        [self lineContext:_context fromPoint:fromRow toPoint:toRow];
    }
    
    for (NSInteger i = 1; i < columnCount; i ++) {
        CGPoint fromColumn = CGPointMake(kCalendarEleW *i, 0);
        CGPoint toColumn = CGPointMake(kCalendarEleW * i, kCalendarEleH * (rowCount-1));
        [self lineContext:_context fromPoint:fromColumn toPoint:toColumn];
    }
}

- (void)lineContext:(CGContextRef)context fromPoint:(CGPoint)from toPoint:(CGPoint)to {
    CGMutablePathRef linePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(linePath, NULL, from.x, from.y);
    CGPathAddLineToPoint(linePath, NULL, to.x, to.y);
    
    CGContextAddPath(context, linePath);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPathRelease(linePath);
}

@end
