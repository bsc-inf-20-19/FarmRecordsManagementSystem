import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/screens/add_treatment_page.dart';
import 'package:farm_records_management_system/screens/updateTreatmentPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TreatmentsPage extends StatefulWidget {
  const TreatmentsPage({Key? key}) : super(key: key);

  @override
  _TreatmentsPageState createState() => _TreatmentsPageState();
}

class _TreatmentsPageState extends State<TreatmentsPage> {
  List<Map<String, dynamic>> treatments = []; // Store treatment data
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
      List<Map<String, dynamic>> result = await DatabaseHelper.getTreatments();
      setState(() {
        treatments = result.reversed.toList(); // Ensure data is stored in the state
      });
    } catch (e) {
      debugPrint('Error loading treatments: $e'); // Handle exceptions
    }
  }

  void _applySearchFilter(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        isSearching = false;
        _loadData();
      } else {
        isSearching = true;
        treatments = treatments.where((treatment) {
          return treatment['status'].toLowerCase().contains(searchTerm) ||
              treatment['treatment_type'].toLowerCase().contains(searchTerm) ||
              treatment['product_used'].toLowerCase().contains(searchTerm) ||
              treatment['field'].toLowerCase().contains(searchTerm) ||
              treatment['date'].toLowerCase().contains(searchTerm);
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
            : Text('Treatments'), // Treatment title
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
        itemCount: treatments.length,
        itemBuilder: (context, index) {
          var treatment = treatments[index];
          String formattedDate = _formatDate(treatment["date"]); // Format the date
          String status = treatment['status'];
          Color statusColor = status == 'Done' ? Colors.green : Colors.yellow;

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
                                    builder: (context) => UpdateTreatmentPage(
                                      treatmentId: treatment['id'],
                                    ),
                                  ),
                                ).then((result) {
                                  if (result == true) {
                                    _loadData(); // Refresh after update
                                  }
                                });
                              } else if (value == 'delete') {
                                _showDeleteConfirmationDialog(context, treatment['id']);
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
                          '${treatment["status"]} - $formattedDate',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: statusColor),
                        ),
                        Divider(thickness: .5, color: Colors.black54),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildRow('Status:', treatment['status'], color: statusColor),
                  _buildRow('Treatment Type:', treatment['treatment_type']),
                  _buildRow('Product Used:', treatment['product_used']),
                  _buildRow('Field:', treatment['field']),
                  _buildRow('Quantity:', treatment['quantity'].toString()),
                  _buildRow('Date:', formattedDate),
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
                onAdd: (newTreatment) => _addTreatment(newTreatment),
                onNewFieldRequested: () {
                  // Logic for new fields
                },
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

  void _addTreatment(Map<String, dynamic> newTreatment) async {
    // Automatically fill status based on the selected date
    newTreatment['status'] = DateFormat("yyyy-MM-dd")
            .parse(newTreatment['date'])
            .isBefore(DateTime.now())
        ? 'Done'
        : 'Planned';
    await DatabaseHelper.insertTreatment(newTreatment); // Add new treatment and refresh state
    _loadData();
  }
}
