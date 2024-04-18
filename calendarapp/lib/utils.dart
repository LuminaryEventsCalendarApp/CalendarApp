// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, unused_local_variable

import 'dart:convert';
import 'dart:collection';
import 'package:calendarapp/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  fetchData(); // Changed this line to call the fetchData function
  runApp(const MyApp());
}

Future<void> fetchData() async {
  try {
    var response = await http.get(Uri.parse(''));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Clear existing events
      kEvents.clear();
      // Parse response and update UI
      for (var item in data) {
        // Parse relevant fields, ensuring they are not null
        String? orderStartDate = item['order_start_date'];
        int? orderLengthDays = item['order_length_days'];
        String? orderEndDate = item['order_end_date'];
        String? customerName = item['customer_name'];
        List<Map<String, dynamic>> contents = item['contents'] != null
            ? List<Map<String, dynamic>>.from(item['contents'])
            : [];

        if (orderStartDate != null &&
            orderEndDate != null &&
            orderLengthDays != null &&
            customerName != null) {
          // Calculate order end date based on order length
          DateTime startDate =
              DateTime.parse(orderStartDate.replaceAll('T', ' ').split('.')[0]);
          DateTime endDate = startDate.add(Duration(days: orderLengthDays));

          String eventTitle = 'Order for $customerName';
          Event event = Event(
            title: eventTitle,
            orderStartDate: orderStartDate,
            orderLengthDays: orderLengthDays,
            orderEndDate: endDate.toIso8601String(), // Use calculated end date
            customerName: customerName,
            contents: contents,
          );

          for (int i = 0; i < orderLengthDays; i++) {
            DateTime date = startDate.add(Duration(days: i));
            kEvents.putIfAbsent(date, () => []);
            kEvents[date]!.add(event);
          }

          print('Order Start Date: $orderStartDate');
          print('Order Length Days: $orderLengthDays');
          print('Order End Date: $endDate');
          print('Customer Name: $customerName');
          print('Contents:');
          for (var content in contents) {
            print('- Name: ${content["name"]}');
            print('  Description: ${content["description"]}');
            print('  Price per day: ${content["price_per_day"]}');
            print('  Count: ${content["count"]}');
          }
          print('\n');
        } else {
          print('One or more fields are null in the JSON data');
        }
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

class Event {
  final String title;
  final String orderStartDate;
  final int orderLengthDays;
  final String orderEndDate;
  final String customerName;
  final List<Map<String, dynamic>> contents;

  const Event({
    required this.title,
    required this.orderStartDate,
    required this.orderLengthDays,
    required this.orderEndDate,
    required this.customerName,
    this.contents = const [], // Provide a default value for contents
  });

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
  final DateTime nextWeek = kToday.add(const Duration(days: 7));
  for (var i = 0; i < 7; i++) {
    final DateTime day = kToday.add(Duration(days: i));
    if (kEvents.containsKey(day)) {
      final eventsForDay = kEvents[day]!;
      print('Events for $day:');
      eventsForDay.forEach((event) {
        print('- ${event.title}');
        print('- Order Start Date: ${event.orderStartDate}');
        print('- Order Length Days: ${event.orderLengthDays}');
        print('- Order End Date: ${event.orderEndDate}');
        print('- Customer Name: ${event.customerName}');
        print('Contents:');
        for (var content in event.contents) {
          print('- Name: ${content["name"]}');
          print('  Description: ${content["description"]}');
          print('  Price per day: ${content["price_per_day"]}');
          print('  Count: ${content["count"]}');
        }
      });
    }
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Calendar(),
    );
  }
}
