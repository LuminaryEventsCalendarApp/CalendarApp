import 'package:flutter/material.dart';
import 'calendar.dart';
import 'package:side_navigation/side_navigation.dart';
import 'settings.dart';
import 'inventory.dart';

void main() {
  runApp(const Settings());
}

class Settings extends StatelessWidget {
  const Settings({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MySettingsPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MySettingsPage extends StatefulWidget {
  const MySettingsPage
  ({super.key, required this.title});
  

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MySettingsPage> createState() => _MySettingsPage();
}

class _MySettingsPage extends State<MySettingsPage> {
  Widget build(BuildContext context) {
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

  /// The currently selected index of the bar
  int selectedIndex = 0;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Asetukset'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
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
              title: Text('Kalenteri'),
              onTap: () {
                 Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Calendar()),
          );
                // Add navigation logic for option 1 here
              },
            ),
            ListTile(
              title: Text('Tavaraluettelo'),
              onTap: () {
                 Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Inventory()),
          );
                // Add navigation logic for option 2 here
              },
            ),
            ListTile(
              title: Text('Asetukset'),
              onTap: () {
                 Navigator.pop(context);
                 Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          );
                // Add navigation logic for option 1 here
              },
            ),
            // Add more options as needed
          ],
        ),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Calendar()),
          );
        },
        child: Text('Open Calendar'),
      )),
    );
  }
}