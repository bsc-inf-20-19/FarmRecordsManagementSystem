import 'package:farm_records_management_system/home/screens/databaseHelper.dart';
import 'package:flutter/material.dart';

// StatefulWidget for LivestockScreen
class LivestockScreen extends StatefulWidget {
  @override
  _LivestockScreenState createState() => _LivestockScreenState();
}

// State class for LivestockScreen
class _LivestockScreenState extends State<LivestockScreen> {
  // List to store livestock data
  List<Livestock> livestockList = [];
  // Instance of DatabaseHelper to interact with the database
  final dbHelper = DatabaseHelper();

  // Initializing state
  @override
  void initState() {
    super.initState();
    // Refresh livestock list on initialization
    _refreshLivestockList();
  }

  // Method to refresh the livestock list from the database
  void _refreshLivestockList() async {
    // Query all livestock data from the database
    final data = await dbHelper.queryAllLivestock();
    // Update state with the new data
    setState(() {
      livestockList = data.map((item) => Livestock(
        id: item['id'],
        name: item['name'],
        icon: item['icon'],
      )).toList();
    });
  }

  // Method to add new livestock to the database
  void _addNewLivestock(String name, IconData icon) async {
    // Create a new Livestock object
    final newLivestock = Livestock(name: name, icon: icon.codePoint);
    // Insert the new livestock into the database
    await dbHelper.insertLivestock(newLivestock.toMap());
    // Refresh the livestock list
    _refreshLivestockList();
  }

  // Method to delete livestock from the database
  void _deleteLivestock(int id) async {
    // Delete the livestock with the specified id from the database
    await dbHelper.deleteLivestock(id);
    // Refresh the livestock list
    _refreshLivestockList();
  }

  // Method to show a dialog for adding new livestock
  void _showAddLivestockDialog() {
    final TextEditingController nameController = TextEditingController();
    IconData selectedIcon = Icons.pets;

    // Show a dialog with a form to add new livestock
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add New Livestock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              DropdownButton<IconData>(
                value: selectedIcon,
                items: [
                  DropdownMenuItem(child: Text('Cattle'), value: Icons.agriculture),
                  DropdownMenuItem(child: Text('Poultry'), value: Icons.egg),
                  DropdownMenuItem(child: Text('Pig'), value: Icons.pets),
                ],
                onChanged: (IconData? value) {
                  setState(() {
                    selectedIcon = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addNewLivestock(nameController.text, selectedIcon);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  // Building the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livestock'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Implement navigation back if needed
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Implement notifications if needed
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
        itemCount: livestockList.length + 1,
        itemBuilder: (context, index) {
          if (index == livestockList.length) {
            return GestureDetector(
              onTap: _showAddLivestockDialog,
              child: Card(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(Icons.add),
                ),
              ),
            );
          }
          final livestock = livestockList[index];
          return Card(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconData(livestock.icon, fontFamily: 'MaterialIcons'), size: 50),
                    SizedBox(height: 8.0),
                    Text(livestock.name),
                  ],
                ),
                Positioned(
                  right: 0,
                  child: PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == 'delete') {
                        _deleteLivestock(livestock.id!);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    icon: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Livestock model class
class Livestock {
  final int? id;
  final String name;
  final int icon;

  // Constructor
  Livestock({this.id, required this.name, required this.icon});

  // Convert Livestock object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}
