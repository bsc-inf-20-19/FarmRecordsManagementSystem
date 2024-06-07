import 'package:farm_records_management_system/Pages/newField.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FieldListScreen extends StatefulWidget {
  const FieldListScreen({Key? key}) : super(key: key);

  @override
  _FieldListScreenState createState() => _FieldListScreenState();
}

class _FieldListScreenState extends State<FieldListScreen> {
  List<Map<String, dynamic>> fields = [];
  late TextEditingController searchController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadFields();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFields() async {
    try {
      List<Map<String, dynamic>> result = await DatabaseHelper.getFields();
      setState(() {
        fields = result.reversed.toList();
      });
    } catch (e) {
      debugPrint('Error loading fields: $e');
    }
  }

  void _applySearchFilter(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        isSearching = false;
        _loadFields();
      } else {
        isSearching = true;
        fields = fields.where((field) {
          return field['fieldName'].toLowerCase().contains(searchTerm) ||
                 field['fieldType'].toLowerCase().contains(searchTerm) ||
                 field['lightProfile'].toLowerCase().contains(searchTerm) ||
                 field['fieldStatus'].toLowerCase().contains(searchTerm) ||
                 field['notes'].toLowerCase().contains(searchTerm);
        }).toList();
      }
    });
  }

  Widget _buildRow(String label, String value, {Color? color}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 50, bottom: 10),
              child: Text(
                value,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18, color: color),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                onChanged: (value) => _applySearchFilter(value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search by name, type, or status',
                  border: InputBorder.none,
                ),
              )
            : Text('Field List'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: fields.length,
        itemBuilder: (context, index) {
          var field = fields[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewFieldPage(
                                      onAdd: (newField) {
                                        setState(() {
                                          fields[index] = newField;
                                        });
                                      },
                                    ),
                                  ),
                                ).then((result) {
                                  if (result == true) {
                                    _loadFields();
                                  }
                                });
                              } else if (value == 'delete') {
                                await DatabaseHelper.deleteField(field['id']);
                                _loadFields();
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert),
                          ),
                        ),
                        Text(
                          field['fieldName'] ?? 'No Name',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Divider(thickness: .5, color: Colors.black54),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildRow('Field Type:', field['fieldType'] ?? 'N/A'),
                  _buildRow('Light Profile:', field['lightProfile'] ?? 'N/A'),
                  _buildRow('Field Status:', field['fieldStatus'] ?? 'N/A'),
                  _buildRow('Field Size:', field['fieldSize']?.toString() ?? 'N/A'),
                  _buildRow('Notes:', field['notes'] ?? 'N/A'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewFieldPage(onAdd: _handleAddField),
            ),
          );
          if (result == true) {
            _loadFields();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _handleAddField(Map<String, dynamic> newField) async {
    await DatabaseHelper.insertField(newField);
    _loadFields();
  }
}
