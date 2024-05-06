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

  void _loadData() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.getTreatments();
    setState(() {
      treatments = result;
    });
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
          return ListTile(
            title: Text(
              '${treatment["status"]} - ${DateFormat("yyyy-MM-dd").format(DateTime.parse(treatment["date"]))}',
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
                existingFields: ['Maize', 'GroundNuts'],
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
