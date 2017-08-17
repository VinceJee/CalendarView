//
//  CalendarViewController.h
//  CalendarDemo
//
//  Created by VinceJee on 2017/8/7.
//  Copyright © 2017年 VinceJee. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarView.h"

@interface CalendarViewController()<UITableViewDelegate,UITableViewDataSource> {
    
    CalendarView *_calendarView;
    
    UILabel *_titleLabel; // 月份
    UISwipeGestureRecognizer *_swipeL;
    UISwipeGestureRecognizer *_swipeR;
    
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation CalendarViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(backToToday)];
    
    [self bottomView];

}

- (void)bottomView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:_scrollView];
    
    
    [_scrollView addSubview:[self setupCalendarView]];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(_calendarView.bounds.size.height, 0, 0, 0);
    
    [_scrollView addSubview:self.tableView];
    
}

- (void)backToToday {
    [_calendarView backToToday];
    [self.tableView reloadData];
}

- (void)btnL {
    [self swipe:_swipeR];
}

- (void)btnR {
    [self swipe:_swipeL];
}

- (CalendarView *)setupCalendarView {
  
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0);
    _calendarView = [[CalendarView alloc] initWithFrame:frame];
    [self.view addSubview:_calendarView];
    
    _swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    _swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    [_calendarView addGestureRecognizer:_swipeL];
    
    
    _swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    _swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    [_calendarView addGestureRecognizer:_swipeR];
    
    return _calendarView;
}

- (void)swipe:(UISwipeGestureRecognizer *)swipeGes {
    
    [_calendarView.layer removeAllAnimations];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.endProgress = 1.0;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    
    if (swipeGes.direction == UISwipeGestureRecognizerDirectionLeft) {
        animation.subtype = kCATransitionFromRight;
        [_calendarView nextMonth];
    }
    
    if (swipeGes.direction == UISwipeGestureRecognizerDirectionRight) {
        animation.subtype = kCATransitionFromLeft;
        [_calendarView previousMonth];
    }
    
    _titleLabel.text = [_calendarView titleLabelStr];
    [_calendarView.layer addAnimation:animation forKey:@"transitionMenstrual"];
    
    [UIView animateWithDuration:0.24 animations:^{
        
        [self.tableView setContentInset:UIEdgeInsetsMake(_calendarView.bounds.size.height, 0, 0, 0)];
    }];
}

#pragma mark - table view data source & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row-%@", @(indexPath.row)];
    return cell;
}

#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//     NSLog(@"---0");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//     NSLog(@"---1");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"---2");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"---3");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        CGRect frame = _calendarView.frame;
        
        frame.origin.y += scrollView.contentOffset.y+64;
        
        _calendarView.frame = frame;
        
    }
    
//    
//    
//    NSLog(@"---:%0.0f",scrollView.contentOffset.y);
//    
//    CGFloat offsetY = scrollView.contentOffset.y + 64;
//    
//    if (offsetY <= 0) {
//        
//        self.navigationController.navigationBar.alpha = 0.0;
//        
//    } else {
//        
//        self.navigationController.navigationBar.alpha = offsetY;
//    }
//    
//    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
