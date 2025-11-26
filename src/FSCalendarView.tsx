import React, { forwardRef, useImperativeHandle, useRef } from 'react';
import type { HostComponent } from 'react-native';
import type { ViewStyle } from 'react-native';
import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypes';

//
// Native event types
//
type DateSelectedEvent = {
  date: string;
};

type MonthChangedEvent = {
  month: string;
};

//
// Native props for the codegen component
//
export interface FSCalendarNativeProps {
  style?: ViewStyle;
  onDateSelected?: DirectEventHandler<DateSelectedEvent>;
  onMonthChanged?: DirectEventHandler<MonthChangedEvent>;
  firstWeekday?: number;
  scope?: 'month' | 'week';
  selectionColor?: string;
  todayColor?: string;
  headerTitleColor?: string;
  weekdayTextColor?: string;
  eventDates?: string[];
}

//
// Create the codegen'd native component (Fabric)
//
const NativeFSCalendar =
  codegenNativeComponent<FSCalendarNativeProps>('RNFSCalendar');

//
// Commands shape for codegenNativeCommands
//
interface NativeCommands {
  selectDate: (ref: React.ComponentRef<HostComponent<FSCalendarNativeProps>>, date: string) => void;
  setCurrentPage: (ref: React.ComponentRef<HostComponent<FSCalendarNativeProps>>, date: string) => void;
  addEvent: (ref: React.ComponentRef<HostComponent<FSCalendarNativeProps>>, date: string) => void;
  removeEvent: (ref: React.ComponentRef<HostComponent<FSCalendarNativeProps>>, date: string) => void;
}

const Commands = codegenNativeCommands<NativeCommands>({
  supportedCommands: [
    'selectDate',
    'setCurrentPage',
    'addEvent',
    'removeEvent',
  ],
});

export interface FSCalendarRef {
  selectDate: (date: string) => void;
  setCurrentPage: (date: string) => void;
  addEvent: (date: string) => void;
  removeEvent: (date: string) => void;
}

interface FSCalendarProps {
  style?: ViewStyle;
  onDateSelected?: (date: string) => void;
  onMonthChanged?: (month: string) => void;
  firstWeekday?: number;
  scope?: 'month' | 'week';
  selectionColor?: string;
  todayColor?: string;
  headerTitleColor?: string;
  weekdayTextColor?: string;
  eventDates?: string[];
}

const FSCalendarView = forwardRef<FSCalendarRef, FSCalendarProps>((props, ref) => {
  const nativeRef = useRef<React.ComponentRef<typeof NativeFSCalendar> | null>(null);

  useImperativeHandle(ref, () => ({
    selectDate: (date: string) => {
      if (nativeRef.current && Commands?.selectDate) {
        Commands.selectDate(nativeRef.current, date);
      }
    },
    setCurrentPage: (date: string) => {
      if (nativeRef.current && Commands?.setCurrentPage) {
        Commands.setCurrentPage(nativeRef.current, date);
      }
    },
    addEvent: (date: string) => {
      if (nativeRef.current && Commands?.addEvent) {
        Commands.addEvent(nativeRef.current, date);
      }
    },
    removeEvent: (date: string) => {
      if (nativeRef.current && Commands?.removeEvent) {
        Commands.removeEvent(nativeRef.current, date);
      }
    },
  }));

  const handleDateSelected = (event: any) => {
    props.onDateSelected?.(event.nativeEvent.date);
  };

  const handleMonthChanged = (event: any) => {
    props.onMonthChanged?.(event.nativeEvent.month);
  };

  const nativeProps: FSCalendarNativeProps = {
    style: props.style,
    onDateSelected: handleDateSelected,
    onMonthChanged: handleMonthChanged,
    firstWeekday: props.firstWeekday,
    scope: props.scope,
    selectionColor: props.selectionColor,
    todayColor: props.todayColor,
    headerTitleColor: props.headerTitleColor,
    weekdayTextColor: props.weekdayTextColor,
    eventDates: props.eventDates,
  };

  return <NativeFSCalendar ref={nativeRef} {...nativeProps} />;
});

export default FSCalendarView;