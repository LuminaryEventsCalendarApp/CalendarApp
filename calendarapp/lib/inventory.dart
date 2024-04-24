import 'package:calendarapp/home_page.dart';
import 'package:flutter/material.dart';
import 'calendar.dart';
import 'settings.dart';

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
      home: MyInventoryPage(),
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

// Nämä on testilaitteita, joilla voidaan kokeilla datan hakemista ilman tietokantaa.
/*
  @override
  void initState() {
    super.initState();
    initializeExampleDevices();
  }

  void initializeExampleDevices() {
    devices = [
      {'name': 'Laite 1',
       'current_stock': 10,
       'total_stock': 10,
        'description': 'Description of Device 1',
        'price_per_day': 44,
        'type': 'Lavatekniikka'
        },

      {'name': 'Laite 1',
      'current_stock': 10,
       'total_stock': 10,
        'description': 'Description of Device 1',
        'price_per_day': 44,
        'type': 'Lavatekniikka'
        },
        
        
    ];
  }
*/

//Hakee laitteet databasesta
  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse("https://mekelektro.com/devices"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          devices = List<Map<String, dynamic>>.from(data.map((device) {
            return {
              'device': device['id'],
              'name': device['name'],
              'total_stock': device['total_stock'],
              'current_stock': device['current_stock'],
              'description': device['description'],
              'price_per_day': device['price_per_day'],
              'type': device['type']
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
    final url = Uri.parse('https://mekelektro.com/devices/$deviceId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Device successfully deleted, update the UI accordingly
        setState(() {
          devices!.removeWhere((device) =>
              device.containsKey('device') && device['device'] == deviceId);
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
    final url = Uri.parse('https://mekelektro.com/devices');
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
          'type': newDevice['type'],
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
                // Poistaa laitteen
                deleteDevice(device['device']);
                Navigator.pop(context);
              },
              child: const Text('Poista laite'),
            ),
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
        title:
            const Text('Tavaraluettelo', style: TextStyle(color: Colors.white)),
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
                      'assets/luminaryevents.png'), // Navigoinnin kuva
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
              title: const Text('Kalenteri',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Calendar()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory, color: Colors.white),
              title: const Text('Tavaraluettelo',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Asetukset',
                  style: TextStyle(color: Colors.white)),
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
              title: const Text('Uudet tilaukset',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
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
      body: devices != null
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: DataTable(
                    columnSpacing: 16.0,
                    dataRowMinHeight: 56.0,
                    dataRowMaxHeight: 56.0,
                    columns: const [
                      DataColumn(label: Text('Nimi')),
                      DataColumn(label: Text('Kuvaus')),
                      DataColumn(label: Text('Tyyppi')),
                      DataColumn(label: Text('Hinta/Päivä')),
                      DataColumn(label: Text('Saatavilla')),
                      DataColumn(label: Text('Yhteensä')),
                      DataColumn(label: Text('Toiminnot')),
                    ],
                    rows: devices!.map((device) {
                      return DataRow(
                        cells: [
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(device['name'].toString()),
                          )),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(device['description'] != null
                                ? '${device['description']}'
                                : 'NULL'),
                          )),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(device['type'] != null
                                ? '${device['type']}'
                                : 'NULL'),
                          )),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(device['price_per_day'] != null
                                ? '${device['price_per_day']}€'
                                : 'NULL '),
                          )),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(device['current_stock'] != null
                                ? '${device['current_stock']}'
                                : 'NULL'),
                          )),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(device['total_stock'] != null
                                ? '${device['total_stock']}'
                                : 'NULL'),
                          )),
                          DataCell(IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              _showOptionsDialog(context, device);
                            },
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            )
          : devices == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Center(
                  child: Text('Failed to fetch data'),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeviceDialog(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDeviceDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController pricePerDayController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();

    String selectedType = 'kokoääni';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lisää uusi laite'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nimi'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Kuvaus'),
                ),
                TextField(
                  controller: pricePerDayController,
                  decoration:
                      const InputDecoration(labelText: 'Hinta per päivä'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue!;
                    });
                  },
                  items: <String>['kokoääni', 'sub', 'dj', 'lavatekniikka']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Tyyppi'),
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Kappalemäärä'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Keskeytä'),
            ),
            TextButton(
              onPressed: () {
                final newDevice = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price_per_day':
                      double.tryParse(pricePerDayController.text) ?? 0.0,
                  'total_stock': int.tryParse(quantityController.text) ?? 0,
                  'type': selectedType,
                };
                // Lisää uuden laitteen
                addDevice(newDevice);
                Navigator.of(context).pop();
              },
              child: const Text('Lisää'),
            ),
          ],
        );
      },
    );
  }
}
