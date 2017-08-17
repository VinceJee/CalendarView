//
//  CalendarView.h
//  CalendarDemo
//
//  Created by VinceJee on 2017/8/7.
//  Copyright © 2017年 VinceJee. All rights reserved.
//

#import <UIKit/UIKit.h>
 
#define kTodaycolor [UIColor redColor]

@interface CalendarView : UIView
 

@property (nonatomic,copy) NSString *dateStr;

- (void)previousMonth;

- (void)nextMonth;

- (NSString *)titleLabelStr;

- (void)backToToday;

@end
