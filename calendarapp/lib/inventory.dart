
import 'package:flutter/material.dart';
import 'calendar.dart';
import 'settings.dart';
import 'new_orders.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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


class MyInventoryPage extends StatefulWidget {
  const MyInventoryPage({Key? key}) : super(key: key);

  @override
  _MyInventoryPageState createState() => _MyInventoryPageState();
}

class _MyInventoryPageState extends State<MyInventoryPage> {
  List<Map<String, dynamic>>? devices;

  @override
  void initState() {
    super.initState();
    initializeExampleDevices();
  }

  void initializeExampleDevices() {
    devices = [
      {'name': 'Device 1', 'quantity': 10, 'description': 'Description of Device 1'},
      {'name': 'Device 2', 'quantity': 5, 'description': 'Description of Device 2'},
    ];
  }


 /*
//Hakee laitteet databasesta
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(""));
     if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          devices = List<Map<String, dynamic>>.from(data.map((device) {
            return {
              'device' : device['id'],
              'name': device['name'],
              'total_stock': device['total_stock'],
              'description' : device ['description'],
              'price_per_day' : device['price_per_day'],
            };
          }));
        });
      } else {
        // If request fails, set devices to an empty list
        setState(() {
          devices = [];
        });
      }
    } catch (e) {
      // If there's an error, set devices to null
      setState(() {
        devices = null;
      });
      print("Error fetching data: $e");
    }
  }
  

@override
  void initState() {
    super.initState();
    fetchData();
  }
  
    //poistaa laitteen tietokannasta
    
     Future<void> deleteDevice(int deviceId) async {
    final url = Uri.parse('/$deviceId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Device successfully deleted, update the UI accordingly
        setState(() {
          devices!.removeWhere((device) => device.containsKey('device') && device['device'] == deviceId);
        });
      } else {
        // Handle error if the delete request fails
        print('Failed to delete device. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any network errors
      print('Error deleting device: $e');
    }
  }
  //Lisää laitteen tietokantaan
  Future<void> addDevice(Map<String, dynamic> newDevice) async {
  final url = Uri.parse(''); // Replace this empty string with the actual URL of your API endpoint
  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': newDevice['name'],
        'description': newDevice['description'],
        'price_per_day': newDevice['price_per_day'],
        'total_stock': newDevice['total_stock'], 
      }),
    );
    if (response.statusCode == 201) {
      // Device successfully added, update the UI accordingly
      setState(() {
        devices!.add(newDevice);
      });
    } else {
      // Handle error if the add request fails
      print('Failed to add device. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any network errors
    print('Error adding device: $e');
  }
}
*/
    //Asetukset toiminto laitteille
   void _showOptionsDialog(BuildContext context, Map<String, dynamic> device) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(device['name']),
        content: Text('Asetukset laitteelle ${device['name']}'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Add your option action here
              // For example, you can delete the device
              // Delete device
               // deleteDevice(device['device']);
                Navigator.pop(context);
              
            },
            child: Text('Poista laite'),
          ),
          // Add more options as needed
        ],
      );
    },
  );
}
  




  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text('Tavaraluettelo', style: TextStyle(color: Colors.white)),

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
              title: const Text('Kalenteri', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Calendar()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory, color: Colors.white),
              title: const Text('Tavaraluettelo', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // No need to navigate to Inventory screen again since we're already on it
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Asetukset', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.white),
              title: const Text('Uudet tilaukset', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const New_orders()),
                );
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
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kalusto', style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(), // Add Spacer widget here
          Text('Kappalemäärä', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 100, 99, 99),
              child: devices != null
                  ? ListView.builder(
                itemCount: devices!.length,
                itemBuilder: (BuildContext context, int index) {
                  final device = devices![index];
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(device['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(device['description'] != null ? '${device['description']}' : 'NULL'),
                        ],
                      ),
                      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text(
              (device['total_stock'] != null ? '${device['total_stock']}' : 'NULL'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                      ),
                      ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Add your options action here
                // For example, you can show a bottom sheet or navigate to a details screen
                _showOptionsDialog(context, device);
              },
            ),
            
                        
                    ],
                    ),
                    ),
                  );
                },
              )
                  : devices == null
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : const Center(
                child: Text('Failed to fetch data'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeviceDialog(context);
          // Add new device action
          // Implement navigation to a screen where users can add new devices
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
  Future<void> _showAddDeviceDialog(BuildContext context) async {
    
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController pricePerDayController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    
    

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lisää uusi laite'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nimi'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Kuvaus'),
                ),
                TextField(
                  controller: pricePerDayController,
                  decoration: InputDecoration(labelText: 'Hinta per päivä'),
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Kappalemäärä'),
                ),
                
                
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Keskeytä'),
            ),
            TextButton(
              onPressed: () {
                final newDevice = {
                  
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price_per_day': double.tryParse(pricePerDayController.text) ?? 0.0,
                  'total_stock': int.tryParse(quantityController.text) ?? 0,
                  
                  
                };
                // Add the new device
               // addDevice(newDevice);
                Navigator.of(context).pop();
              },
              child: Text('Lisää'),
            ),
          ],
        );
      },
    );
  }
}