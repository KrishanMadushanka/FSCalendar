//
//  RNFSCalendarView.h
//  TurboModules
//
//  Created by Krishan Madushanka on 2025-11-20.
//

// RNFSCalendarView.h

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import <FSCalendar/FSCalendar.h>

@interface RNFSCalendarView : UIView <FSCalendarDelegate, FSCalendarDataSource>

// Event handlers - use copy for blocks
@property (nonatomic, copy) RCTDirectEventBlock onDateSelected;
@property (nonatomic, copy) RCTDirectEventBlock onMonthChanged;

// Configuration properties - use strong/copy appropriately
@property (nonatomic, strong) NSNumber *firstWeekday;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *selectionColor;
@property (nonatomic, copy) NSString *todayColor;
@property (nonatomic, copy) NSString *headerTitleColor;
@property (nonatomic, copy) NSString *weekdayTextColor;
@property (nonatomic, strong) NSArray *eventDates;

// Public methods for imperative control
- (void)selectDateFromString:(NSString *)dateString;
- (void)setCurrentPageFromString:(NSString *)dateString;
- (void)addEventForDateString:(NSString *)dateString;
- (void)removeEventForDateString:(NSString *)dateString;

@end
