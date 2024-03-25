// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _enteredText = '';
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay; // Update the selected day
      _focusedDay = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedEvents.value = _getEventsForDay(selectedDay);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableCalendar - Events'),
      ),
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 150,
                    child: TableCalendar<Event>(
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      calendarFormat: _calendarFormat,
                      rangeSelectionMode: _rangeSelectionMode,
                      eventLoader: (day) {
                        return _getEventsForDay(day);
                      },
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarStyle: const CalendarStyle(
                        outsideDaysVisible: false,
                      ),
                      onDaySelected: _onDaySelected,
                      onRangeSelected: _onRangeSelected,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Seuraavat tapahtumat',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _enteredText = value; // Update the entered text
                    });
                  },
                  onSubmitted: (_) {
                    _addEvent(_selectedDay ?? DateTime.now());
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              SingleChildScrollView(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, child) {
                    return Column(
                      children: value.map((event) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onTap: () => print('$event'),
                            title: Text('$event'),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addEvent(DateTime selectedDate) {
    if (kEvents.containsKey(selectedDate)) {
      kEvents[selectedDate]!.add(Event(_enteredText));
    } else {
      kEvents[selectedDate] = [Event(_enteredText)];
    }

    setState(() {
      _enteredText = '';
    });
  }
}
