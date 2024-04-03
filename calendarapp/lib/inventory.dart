import 'package:flutter/material.dart';
import 'calendar.dart';
import 'settings.dart';


void main() {
  runApp(const Inventory());
}

class Inventory extends StatelessWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyInventoryPage(), // Use MyInventoryPage as the home
    );
  }
}

class MyInventoryPage extends StatelessWidget {
  const MyInventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Tavaraluettelo', style:TextStyle(color: Colors.white)),
        centerTitle: true,
        
      ),
      
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
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
              title: const Text('Kalenteri'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Calendar()),
                );
              },
            ),
            ListTile(
              title: const Text('Tavaraluettelo'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Asetukset'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
              );
              },
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