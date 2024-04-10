// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls
import 'dart:convert';
import 'dart:collection';
import 'package:http/http.dart' as http;
import 'package:calendarapp/main.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  retrieveEventsForNext7Days(); // Added this line to call the function
  runApp(const MyApp());
}

Future<void> fetchData() async {
  try {
    var response = await http.get(Uri.parse(''));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Parse response and update UI
      for (var item in data) {
        print('Id: ${item['id']}');
        print('Total Price: ${item['total_price']}');
        print('Order Created At: ${item['order_created_at']}');
        print('Order Start Date: ${item['order_start_date']}');
        print('Order Length Days: ${item['order_length_days']}');
        print('Order End Date: ${item['order_end_date']}');
        print('Payment Due Date: ${item['payment_due_date']}');
        print('Customer Name: ${item['customer_name']}');
        print('Customer Phone Number: ${item['customer_phone_number']}');
        print('Customer Email: ${item['customer_email']}');
        print('Order Status: ${item['order_status']}');
        print('Payment Resolved: ${item['payment_resolved']}');
        print('Contents: ${item['contents']}');
        print('\n'); // Add a line break after each item
      }
    } else {
      // Handle error
      print('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    // Handle exception
    print('Exception: $e');
  }
}

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

void retrieveEventsForNext7Days() {
  // ignore: unused_local_variable
  final DateTime nextWeek = kToday.add(const Duration(days: 7));
  for (var i = 0; i < 7; i++) {
    final DateTime day = kToday.add(Duration(days: i));
    if (kEvents.containsKey(day)) {
      final eventsForDay = kEvents[day]!;
      print('Events for $day:');
      eventsForDay.forEach((event) {
        print('- ${event.title}');
      });
    }
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
