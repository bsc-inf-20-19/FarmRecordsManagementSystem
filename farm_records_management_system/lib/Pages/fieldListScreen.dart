import 'package:flutter/material.dart';
import 'package:farm_records_management_system/Pages/newField.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';

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
      List<Map<String, dynamic>> result = await DatabaseHelper.instance.getFields();
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
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: color),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 50, bottom: 10),
              child: Text(
                value,
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontSize: 18, color: color),
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
                decoration: const InputDecoration(
                  hintText: 'Search by name, type, or status',
                  border: InputBorder.none,
                ),
              )
            : const Text('Field List'),
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
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${field['fieldName']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Spacer(),
                      PopupMenuButton<String>(
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
                            await DatabaseHelper.instance.deleteField(field['id']);
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
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  FieldsListItem(label: 'Field Type', value: field['fieldType']),
                  FieldsListItem(label: 'Light Profile', value: field['lightProfile']),
                  FieldsListItem(label: 'Field Status', value: field['fieldStatus']),
                  FieldsListItem(label: 'Field Size', value: field['fieldSize']?.toString() ?? 'N/A'),
                  FieldsListItem(label: 'Notes', value: field['notes']),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewFieldPage(
                onAdd: (newField) {
                  setState(() {
                    fields.insert(0, newField);
                  });
                },
              ),
            ),
          ).then((result) {
            if (result == true) {
              _loadFields();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FieldsListItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const FieldsListItem({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
