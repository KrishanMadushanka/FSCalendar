import React, {useRef, useState} from 'react';
import {
  SafeAreaView,
  StyleSheet,
  Text,
  View,
  Button,
  ScrollView,
} from 'react-native';
import FSCalendarView, {FSCalendarRef} from './src/FSCalendarView';

function App(): React.JSX.Element {
  const calendarRef = useRef<FSCalendarRef>(null);
  const [selectedDate, setSelectedDate] = useState<string>('');
  const [currentMonth, setCurrentMonth] = useState<string>('');

  const handleDateSelected = (date: string) => {
    console.log('Date selected:', date);
    setSelectedDate(date);
  };

  const handleMonthChanged = (month: string) => {
    console.log('Month changed:', month);
    setCurrentMonth(month);
  };

  const addEventToday = () => {
    const today = new Date().toISOString().split('T')[0];
    calendarRef.current?.addEvent(today);
  };

  const goToToday = () => {
    const today = new Date().toISOString().split('T')[0];
    calendarRef.current?.setCurrentPage(today);
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <View style={styles.header}>
          <Text style={styles.title}>FSCalendar Example</Text>
          {selectedDate ? (
            <Text style={styles.selectedText}>Selected Date: {selectedDate}</Text>
          ) : null}
          {currentMonth ? (
            <Text style={styles.selectedText}>Selected Month: {currentMonth}</Text>
          ) : null}
        </View>

        <FSCalendarView
          ref={calendarRef}
          style={styles.calendar}
          onDateSelected={handleDateSelected}
          onMonthChanged={handleMonthChanged}
          firstWeekday={1} // Monday
          scope="month"
          selectionColor="#3366FF"
          todayColor="#FF9500"
          headerTitleColor="#000000"
          weekdayTextColor="#666666"
          eventDates={['2025-11-28']}
        />

        <View style={styles.buttonContainer}>
          <Button title="Add Event Today" onPress={addEventToday} />
          <View style={styles.spacing} />
          <Button title="Go to Today" onPress={goToToday} />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  header: {
    padding: 20,
    backgroundColor: 'white',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  selectedText: {
    fontSize: 16,
    color: '#666',
  },
  calendar: {
    height: 350,
    backgroundColor: 'white',
    margin: 10,
    borderRadius: 10,
  },
  buttonContainer: {
    padding: 20,
  },
  spacing: {
    height: 10,
  },
});

export default App;