import 'package:farm_records_management_system/screens/add_treatment_page.dart';
import 'package:farm_records_management_system/screens/databaseHelper.dart';
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
      List<Map<String, dynamic>> result = await DatabaseHelper.instance.getTreatments();
      setState(() {
        treatments =
            result.reversed.toList(); // Ensure data is stored in the state
      });
    } catch (e) {
      debugPrint('Error loading treatments: $e'); // Handle exceptions
    }
  }

  void _applySearchFilter(String lowerCase) {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      if (searchTerm.isEmpty) {
        isSearching = false;
        _loadData();
      } else {
        isSearching = true;
        treatments = treatments.where((treatment) {
          // Filter by name, type, or date
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching ? TextField(
          controller: searchController,
          onChanged: (value) {
            _applySearchFilter(value.toLowerCase());
          },
          decoration: InputDecoration(
                  hintText: 'Search by name, type, or date',
                  border: InputBorder.none,
        )
        )
        : Row(
          children: [
            Text('Treatments'), // Treatment title
            SizedBox(width: 10),  // Spacer between title and search
            
          ],
        ),
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
          String formattedDate =
              _formatDate(treatment["date"]); // Format the date
          return ListTile(
            title: Text(
              '${treatment["status"]} - $formattedDate',
            ),
            subtitle: Text(
              'Type: ${treatment["treatment_type"]}, Product: ${treatment["product_used"]}, Field: ${treatment["field"]}, Quantity: ${treatment["quantity"] ?? 0}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
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
                  },
                  icon: const Icon(Icons.edit, color: Colors.green),
                ),
                IconButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteTreatment(treatment['id']);
                    _loadData(); // Refresh after deletion
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
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
                existingFields: const ['Maize', 'GroundNuts'],
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
    newTreatment['status'] = DateFormat("yyyy-MM-dd").parse(newTreatment['date']).isAfter(DateTime.now()) ? 'Planned' : 'Done';  
    await DatabaseHelper.instance.insertTreatments(
        newTreatment); // Add new treatment and refresh state
    _loadData();
  }
}
