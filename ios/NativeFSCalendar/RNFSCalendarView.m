//
//  RNFSCalendarView.m
//  TurboModules
//
//  Created by Krishan Madushanka on 2025-11-20.
//

// RNFSCalendarView.m

#import "RNFSCalendarView.h"

@interface RNFSCalendarView()

@property (nonatomic, strong) FSCalendar *calendar;
@property (nonatomic, strong) NSMutableSet<NSString *> *eventDateStrings;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation RNFSCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupCalendar];
    [self setupDateFormatter];
    self.eventDateStrings = [NSMutableSet set];
  }
  return self;
}

- (void)setupDateFormatter {
  self.dateFormatter = [[NSDateFormatter alloc] init];
  [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
  [self.dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
  [self.dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
}

- (void)setupCalendar {
  self.calendar = [[FSCalendar alloc] initWithFrame:self.bounds];
  self.calendar.dataSource = self;
  self.calendar.delegate = self;
  self.calendar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  // Default appearance
  self.calendar.appearance.headerTitleColor = [UIColor blackColor];
  self.calendar.appearance.weekdayTextColor = [UIColor grayColor];
  self.calendar.appearance.selectionColor = [UIColor blueColor];
  self.calendar.appearance.todayColor = [UIColor orangeColor];
  self.calendar.appearance.eventDefaultColor = [UIColor greenColor];
  
  [self addSubview:self.calendar];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.calendar.frame = self.bounds;
}

// MARK: - Property Setters

- (void)setFirstWeekday:(NSNumber *)firstWeekday {
  if (firstWeekday) {
    self.calendar.firstWeekday = [firstWeekday integerValue];
  }
}

- (void)setScope:(NSString *)scope {
  if ([scope isEqualToString:@"week"]) {
    self.calendar.scope = FSCalendarScopeWeek;
  } else {
    self.calendar.scope = FSCalendarScopeMonth;
  }
}

- (void)setSelectionColor:(NSString *)color {
  if (color) {
    self.calendar.appearance.selectionColor = [self colorFromHexString:color];
  }
}

- (void)setTodayColor:(NSString *)color {
  if (color) {
    self.calendar.appearance.todayColor = [self colorFromHexString:color];
  }
}

- (void)setHeaderTitleColor:(NSString *)color {
  if (color) {
    self.calendar.appearance.headerTitleColor = [self colorFromHexString:color];
  }
}

- (void)setWeekdayTextColor:(NSString *)color {
  if (color) {
    self.calendar.appearance.weekdayTextColor = [self colorFromHexString:color];
  }
}

- (void)setEventDates:(NSArray *)eventDates {
  [self.eventDateStrings removeAllObjects];
  if (eventDates) {
    for (NSString *dateString in eventDates) {
      [self.eventDateStrings addObject:dateString];
    }
  }
  [self.calendar reloadData];
}

// MARK: - Public Methods

- (void)selectDateFromString:(NSString *)dateString {
  NSDate *date = [self.dateFormatter dateFromString:dateString];
  if (date) {
    [self.calendar selectDate:date scrollToDate:YES];
  }
}

- (void)setCurrentPageFromString:(NSString *)dateString {
  NSDate *date = [self.dateFormatter dateFromString:dateString];
  if (date) {
    [self.calendar setCurrentPage:date animated:YES];
  }
}

- (void)addEventForDateString:(NSString *)dateString {
  [self.eventDateStrings addObject:dateString];
  [self.calendar reloadData];
}

- (void)removeEventForDateString:(NSString *)dateString {
  [self.eventDateStrings removeObject:dateString];
  [self.calendar reloadData];
}

// MARK: - FSCalendarDataSource

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
  // Convert the date to string using our formatter (which uses GMT+0)
  NSString *dateString = [self.dateFormatter stringFromDate:date];
   
  return [self.eventDateStrings containsObject:dateString] ? 1 : 0;
}

// Helper method to compare dates without time component
- (BOOL)isSameDay:(NSDate *)date1 asDate:(NSDate *)date2 {
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSDateComponents *components1 = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date1];
  NSDateComponents *components2 = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date2];
  return components1.year == components2.year &&
         components1.month == components2.month &&
         components1.day == components2.day;
}

// MARK: - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
  NSString *dateString = [self.dateFormatter stringFromDate:date];
  if (self.onDateSelected) {
    self.onDateSelected(@{@"date": dateString});
  }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
  NSString *monthString = [self.dateFormatter stringFromDate:calendar.currentPage];
  if (self.onMonthChanged) {
    self.onMonthChanged(@{@"month": monthString});
  }
}

// MARK: - Helper Methods

- (UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  if ([hexString hasPrefix:@"#"]) {
    [scanner setScanLocation:1];
  }
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                         green:((rgbValue & 0xFF00) >> 8)/255.0
                          blue:(rgbValue & 0xFF)/255.0
                         alpha:1.0];
}

@end
