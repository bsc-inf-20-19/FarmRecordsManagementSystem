import 'package:farm_records_management_system/home/screens/add_treatment_page.dart';
import 'package:farm_records_management_system/home/screens/databaseHelper.dart';
import 'package:farm_records_management_system/home/screens/updateTreatmentPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class HarvestsViewPage extends StatefulWidget {
  const HarvestsViewPage({Key? key}) : super(key: key);

  @override
  _HarvestsViewPageState createState() => _HarvestsViewPageState();
}

class _HarvestsViewPageState extends State<HarvestsViewPage> {
  List<Map<String, dynamic>> harvests = []; // Store treatment data
  late TextEditingController searchController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData(); // Load initial data
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> result = await DatabaseHelper.getHarvests();
      setState(() {
        harvests = result.reversed.toList(); // Ensure data is stored in the state
      });
    } catch (e) {
      debugPrint('Error loading harvests: $e'); // Handle exceptions
    }
  }

  void _applySearchFilter(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        isSearching = false;
        _loadData();
      } else {
        isSearching = true;
        harvests = harvests.where((harvest) {
          return harvest['batch'].toLowerCase().contains(searchTerm) ||
              harvest['harvest_quantity'].toLowerCase().contains(searchTerm) ||
              harvest['harvest_quality'].toLowerCase().contains(searchTerm) ||
              harvest['unity-cost'].toLowerCase().contains(searchTerm) ||
              harvest['harvest_income'].toLowerCase().contains(searchTerm) ||
              harvest['date'].toLowerCase().contains(searchTerm);
        }).toList();
      }
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 'Invalid Date'; // Fallback for null or empty date strings
    }

    try {
      final date = DateTime.parse(dateStr); // Attempt to parse the date
      return DateFormat("yyyy-MM-dd").format(date); // Format the date
    } catch (e) {
      debugPrint('Invalid date format: $e'); // Handle parsing exceptions
      return 'Invalid Date'; // Fallback for invalid format
    }
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

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int treatmentId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this treatment?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await DatabaseHelper.deleteTreatment(treatmentId);
                _loadData(); // Refresh after deletion
                Navigator.of(context).pop(); // Close the dialog
              },
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
        title: isSearching
            ? TextField(
                controller: searchController,
                onChanged: (value) => _applySearchFilter(value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search by name, type, or date',
                  border: InputBorder.none,
                ),
              )
            : Text('Harvest'), // Harvest title
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear(); // Clear search field when closing
                }
                isSearching = !isSearching; // Toggle search state
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: harvests.length,
        itemBuilder: (context, index) {
          var harvest = harvests[index];
          String formattedDate = _formatDate(harvest["date"]); // Format the date
          // String status = harvest['status'];
          // Color statusColor = status == 'Done' ? Colors.green : Colors.yellow;

          return 
           //Change ListTile to Card
          Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        //Harvested Crop Name
                        '${harvest["harvest_type"]}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Align(
                          alignment: Alignment.topRight,
                          child: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateHarvestPage(
                                     harvestId:harvest['id'],
                                    ),
                                  ),
                                ).then((result) {
                                  if (result == true) {
                                    _loadData(); // Refresh after update
                                  }
                                });
                              } else if (value == 'delete') {
                                _showDeleteConfirmationDialog(context,harvest['id']);
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
                      // Icon(Icons.more_vert),
                    ],
                  ),
                  Divider(thickness: .5, color: Colors.black54),
                  SizedBox(height: 8),
                  HarvestItem(label: 'Harvest date', value: '$formattedDate'),
                  HarvestItem(label: 'Batch No', value: '${harvest["batch"]}'),
                  HarvestItem(label: 'Harvest Quantity', value: '${harvest["harvest_quantity"]}'),
                  HarvestItem(label: 'Harvest quality', value: ' ${harvest["harvest_quality"]}'),
                  HarvestItem(label: 'Unit cost', value: '${harvest["unity-cost"]}'),
                  HarvestItem(label: 'Harvest income', value: '${harvest["harvest_income"] ?? 0}'),
                  HarvestItem(label: 'Harvest Note', value: '${harvest["harvest_note"] ?? 0}'),
                ],
              ),
            ),
          );
        
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final addedTreatment = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTreatmentPage(
                onAdd: (newHarvest) => _addTreatment(newHarvest),
                onNewFieldRequested: () {
                  // Logic for new fields
                }, existingFields: [],
              ),
            ),
          );
          if (addedTreatment != null) {
            _loadData(); // Refresh after successful addition
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTreatment(Map<String, dynamic> newHarvest) async {
    // Automatically fill status based on the selected date
    newHarvest['status'] = DateFormat("yyyy-MM-dd")
            .parse(newHarvest['date'])
            .isBefore(DateTime.now())
        ? 'Done'
        : 'Planned';
    await DatabaseHelper.insertHarvest(newHarvest); // Add new harvest and refresh state
    _loadData();
  }
}

// ignore: must_be_immutable
class HarvestItem extends StatelessWidget {
  final String label;
  final String value;

  HarvestItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
