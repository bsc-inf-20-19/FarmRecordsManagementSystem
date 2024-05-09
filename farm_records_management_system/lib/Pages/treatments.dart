import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farm_records_management_system/Pages/databaseHelper.dart';
import 'package:farm_records_management_system/Pages/updateTreatmentPage.dart';
import 'package:farm_records_management_system/Pages/add_treatment_page.dart';

class TreatmentsPage extends StatefulWidget {
  const TreatmentsPage({Key? key}) : super(key: key);

  @override
  _TreatmentsPageState createState() => _TreatmentsPageState();
}

class _TreatmentsPageState extends State<TreatmentsPage> {
  List<Map<String, dynamic>> treatments = []; // Store treatment data

  @override
  void initState() {
    super.initState();
    _loadData(); // Load initial data
  }

   Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> result = await DatabaseHelper.getTreatments();
      setState(() {
        treatments = result; // Ensure data is stored in the state
      });
    } catch (e) {
      debugPrint('Error loading treatments: $e'); // Handle exceptions
    }
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
        title: const Text('Treatments'),
      ),
      body: ListView.builder(
        itemCount: treatments.length,
        itemBuilder: (context, index) {
          var treatment = treatments[index];
          String formattedDate = _formatDate(treatment["date"]); // Format the date
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
                    await DatabaseHelper.deleteTreatment(treatment['id']);
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTreatmentPage(
                onAdd: _addTreatment,
                existingFields: const ['Maize', 'GroundNuts'],
                onNewFieldRequested: () {
                  // Logic for new fields
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTreatment(Map<String, dynamic> newTreatment) {
    setState(() {
      treatments.add(newTreatment); // Add new treatment and refresh state
    });
  }
}
