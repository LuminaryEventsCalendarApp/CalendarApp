import 'package:flutter/material.dart';
import 'calendar.dart';
import 'settings.dart';
import 'new_orders.dart';


void main() {
  runApp(const Inventory());
}

class Inventory extends StatelessWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyInventoryPage(), // Use MyInventoryPage as the home
    );
  }
}

class MyInventoryPage extends StatelessWidget {
  const MyInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Tavaraluettelo', style:TextStyle(color: Colors.white)),
        centerTitle: true,
        
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
            MaterialPageRoute(builder: (context) => const Calendar()),
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
      body: Container(
        color: const Color.fromARGB(255, 100, 99, 99),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
               title: Text('Kalusto', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
               
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('KPL', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: Colors.white)),
                  SizedBox(width: 16), 
                ],
              ),
            ),
            Expanded(
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              
              child: ExpansionTile(
                title: Row(
                  children: [
                    Text('Paketti $index'),
                    const Spacer(),
                    const Text('10'), // Example quantity, replace with actual quantity
                   ],
                      ),
                      children: const [
                        ListTile(
                          title: Row(
                            children: [
                              Text('T.BOX pro 112'),
                              Spacer(),
                              Text('5'), // Example quantity for sub-item, replace with actual quantity
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Text('Jatkojohto'),
                              Spacer(),
                              Text('1'), // Example quantity for sub-item, replace with actual quantity
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Text('Virtajohto'),
                              Spacer(),
                              Text('1'), // Example quantity for sub-item, replace with actual quantity
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}