// ignore_for_file: depend_on_referenced_packages, unused_local_variable

import 'dart:convert';
import 'dart:collection';
import 'package:calendarapp/calendar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

// Event model class
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
    this.contents = const [],
  });

  @override
  String toString() => title;
}

// Example events map
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

// Helper functions to manage events
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

// Function to fetch event data for a selected day
Future<Map<String, dynamic>> fetchMapData(DateTime selectedDay) async {
  try {
    var response = await http.get(
      Uri.parse('https://mekelektro.com/orders?date=${selectedDay.toString()}'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw 'Failed to fetch data: ${response.statusCode}';
    }
  } catch (e) {
    throw 'Exception fetching data: $e';
  }
}

// Function to fetch event data
Future<void> fetchData() async {
  try {
    var response = await http.get(Uri.parse('https://mekelektro.com/orders?date='));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      kEvents.clear();
      for (var item in data) {
        String? orderStartDate = item['order_start_date'];
        int? orderLengthDays = item['order_length_days'];
        String? orderEndDate = item['order_end_date'];
        String? customerName = item['customer_name'];
        dynamic contentsData = item['contents'];
        List<Map<String, dynamic>> contents = [];

        if (contentsData != null) {
          if (contentsData is List<dynamic>) {
            // Handle the case where contentsData is a list
            contents = List<Map<String, dynamic>>.from(contentsData.cast<Map<String, dynamic>>());
          } else {
            // Handle other scenarios, like if contentsData is a single map or other types
            // You can add custom logic here based on your requirements
            print('Unexpected contents data format: $contentsData');
          }
        }

        if (orderStartDate != null &&
            orderEndDate != null &&
            orderLengthDays != null &&
            customerName != null) {
          DateTime startDate = DateTime.parse(orderStartDate.replaceAll('T', ' ').split('.')[0]);
          DateTime endDate = startDate.add(Duration(days: orderLengthDays));

          String eventTitle = 'Order for $customerName';
          Event event = Event(
            title: eventTitle,
            orderStartDate: orderStartDate,
            orderLengthDays: orderLengthDays,
            orderEndDate: endDate.toIso8601String(),
            customerName: customerName,
            contents: contents,
          );

          for (int i = 0; i < orderLengthDays; i++) {
            DateTime date = startDate.add(Duration(days: i));
            kEvents.putIfAbsent(date, () => []);
            kEvents[date]!.add(event);
          }
        } else {
          print('One or more fields are null in the JSON data');
        }
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}





// Function to retrieve events for the next 7 days
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

// Main app widget
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
