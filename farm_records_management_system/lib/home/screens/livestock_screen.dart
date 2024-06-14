import 'package:flutter/material.dart';

class LivestockScreen extends StatefulWidget {
  @override
  _LivestockScreenState createState() => _LivestockScreenState();
}

class _LivestockScreenState extends State<LivestockScreen> {
  List<Livestock> livestockList = [
    Livestock(name: 'Cattle', icon: Icons.agriculture.codePoint),
    Livestock(name: 'Poultry', icon: Icons.egg.codePoint),
    Livestock(name: 'Goat', icon: Icons.pets.codePoint),
  ];

  void _addNewLivestock(String name, IconData icon) {
    setState(() {
      livestockList.add(Livestock(name: name, icon: icon.codePoint));
    });
  }

  void _deleteLivestock(int index) {
    setState(() {
      livestockList.removeAt(index);
    });
  }

  void _showAddLivestockDialog() {
    final TextEditingController nameController = TextEditingController();
    IconData selectedIcon = Icons.pets;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                DropdownMenuItem(
                  value: Icons.agriculture,
                  child: Row(
                    children: [
                      Icon(Icons.agriculture),
                      SizedBox(width: 8),
                      Text('Cattle'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: Icons.egg,
                  child: Row(
                    children: [
                      Icon(Icons.egg),
                      SizedBox(width: 8),
                      Text('Poultry'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: Icons.pets,
                  child: Row(
                    children: [
                      Icon(Icons.pets),
                      SizedBox(width: 8),
                      Text('Goat'),
                    ],
                  ),
                ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {},
        ),
        title: Text('Livestock', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          padding: EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),
          itemCount: livestockList.length + 1,
          itemBuilder: (context, index) {
            if (index == livestockList.length) {
              return InkWell(
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
                          _deleteLivestock(index);
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
      ),
    );
  }
}

class Livestock {
  final String name;
  final int icon;

  Livestock({required this.name, required this.icon});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
    };
  }
}
