// RNFSCalendarViewManager.m

#import "RNFSCalendarViewManager.h"
#import "RNFSCalendarView.h"
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>

@implementation RNFSCalendarViewManager

RCT_EXPORT_MODULE(RNFSCalendar)

- (UIView *)view {
  return [[RNFSCalendarView alloc] init];
}

// Props
RCT_EXPORT_VIEW_PROPERTY(onDateSelected, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMonthChanged, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(firstWeekday, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(scope, NSString)
RCT_EXPORT_VIEW_PROPERTY(selectionColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(todayColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(headerTitleColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(weekdayTextColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(eventDates, NSArray)

// Commands - Fabric-compatible approach
RCT_EXPORT_METHOD(selectDate:(nonnull NSNumber *)reactTag date:(NSString *)dateString) {
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
    RNFSCalendarView *view = (RNFSCalendarView *)viewRegistry[reactTag];
    if ([view isKindOfClass:[RNFSCalendarView class]]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [view selectDateFromString:dateString];
      });
    }
  }];
}

RCT_EXPORT_METHOD(setCurrentPage:(nonnull NSNumber *)reactTag date:(NSString *)dateString) {
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
    RNFSCalendarView *view = (RNFSCalendarView *)viewRegistry[reactTag];
    if ([view isKindOfClass:[RNFSCalendarView class]]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [view setCurrentPageFromString:dateString];
      });
    }
  }];
}

RCT_EXPORT_METHOD(addEvent:(nonnull NSNumber *)reactTag date:(NSString *)dateString) {
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
    RNFSCalendarView *view = (RNFSCalendarView *)viewRegistry[reactTag];
    if ([view isKindOfClass:[RNFSCalendarView class]]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [view addEventForDateString:dateString];
      });
    }
  }];
}

RCT_EXPORT_METHOD(removeEvent:(nonnull NSNumber *)reactTag date:(NSString *)dateString) {
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
    RNFSCalendarView *view = (RNFSCalendarView *)viewRegistry[reactTag];
    if ([view isKindOfClass:[RNFSCalendarView class]]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [view removeEventForDateString:dateString];
      });
    }
  }];
}

@end
