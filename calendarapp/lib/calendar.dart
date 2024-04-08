import 'package:calendarapp/new_orders.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:side_navigation/side_navigation.dart';
import 'settings.dart';
import 'inventory.dart';


import '../utils.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String _enteredText = '';
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<Widget> views = const [
    Center(
      child: Text('Dashboard'),
    ),
    Center(
      child: Text('Account'),
    ),
    Center(
      child: Text('Settings'),
    ),
  ];

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
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
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
    final List<Widget> nextSevenDaysEvents = [];

    final DateTime nextWeek = kToday.add(const Duration(days: 7));
    for (int i = 0; i < 7; i++) {
      final DateTime day = kToday.add(Duration(days: i));
      if (kEvents.containsKey(day)) {
        final eventsForDay = kEvents[day]!;
        nextSevenDaysEvents.add(
          Text(
            '${day.day}/${day.month} tapahtumat:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
        for (final event in eventsForDay) {
          nextSevenDaysEvents.add(
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Tapahtuman tiedot ${day.day}/${day.month}'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Tarvittavat paketit tapahtumaan: ${event.title}'),
                          SizedBox(height: 16),
                          Text(
                            'Paketti',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),                           
                            ), 
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Sulje'),
                        ),
                      ],
                    );
                  },
                );
              },
               child: Padding(
                padding: EdgeInsets.only(left: 10),
              child: ElevatedButton(
                onPressed: null,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(125, 30)),
                  maximumSize: MaterialStateProperty.all(Size(125, 30)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    ),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  textStyle: MaterialStateProperty.all(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                ),
                child: Text(event.title, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
              ),
            ),
          )));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalenteri ja tapahtumat'),
      ),
       drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/luminaryevents.png'), // Your background image
              fit: BoxFit.cover,
            ),
              ),
              child: Text(
                'Navigointi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.white),
              title: const Text('Kalenteri',style: TextStyle(color: Colors.white),),
              onTap: () {
                 Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Calendar()),
          );
                // Add navigation logic for option 1 here
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory, color: Colors.white),
              title: const Text('Tavaraluettelo',style: TextStyle(color: Colors.white),),
              onTap: () {
                 Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Inventory()),
          );
                // Add navigation logic for option 2 here
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Asetukset',style: TextStyle(color: Colors.white),),
              onTap: () {
                 Navigator.pop(context);
                 Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Settings()),
          );
                // Add navigation logic for option 1 here
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.white),
              title: const Text('Uudet tilaukset',style: TextStyle(color: Colors.white),),
              onTap: () {
                 Navigator.pop(context);
                 Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const New_orders()),
          );
                // Add navigation logic for option 1 here
              },
            ),
            // Add more options as needed
            const ListTile(
              title: Text(
                '© 2024 Luminary Events',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: 340,
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
                    setState(() {
                      _focusedDay = focusedDay;
                      _selectedDay = focusedDay; // Update _selectedDay
                      _selectedEvents.value = _getEventsForDay(focusedDay);
                    });
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
                hintText: 'Uusi tapahtuma',
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
          Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'Seuraavan viikon tapahtumat:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              
              SizedBox(height: 8),
              ...nextSevenDaysEvents,
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

    setState(() {});
  }
}