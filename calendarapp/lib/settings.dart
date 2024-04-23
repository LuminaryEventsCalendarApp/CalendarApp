import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'calendar.dart';
import 'inventory.dart';
import 'new_orders.dart';
import 'home_page.dart';

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
  const MySettingsPage({super.key, required this.title});

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
  @override
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
      Center(child: Text('Logout'))
    ];

    /// The currently selected index of the bar
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
        actions: const [],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text('Asetukset', style: TextStyle(color: Colors.white)),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/luminaryevents.png'), // Your background image
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
              title: const Text(
                'Kalenteri',
                style: TextStyle(color: Color.fromARGB(255, 247, 246, 246)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Calendar()),
                );
                // Add navigation logic for option 1 here
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory, color: Colors.white),
              title: const Text(
                'Tavaraluettelo',
                style: TextStyle(color: Colors.white),
              ),
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
              title: const Text(
                'Asetukset',
                style: TextStyle(color: Colors.white),
              ),
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
              title: const Text(
                'Uudet tilaukset',
                style: TextStyle(color: Colors.white),
              ),
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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Calendar()),
            );
          },
          child: const Text('Open Calendar'),
        ),
      ),
    );
  }
}
