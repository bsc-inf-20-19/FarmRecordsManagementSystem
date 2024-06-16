import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/screens/add_treatment_page.dart';
import 'package:farm_records_management_system/screens/updateTreatmentPage.dart';
import 'package:farm_records_management_system/database/pdfHepher.dart';

class TreatmentsPage extends StatefulWidget {
  const TreatmentsPage({super.key});

  @override
  _TreatmentsPageState createState() => _TreatmentsPageState();
}

class _TreatmentsPageState extends State<TreatmentsPage> {
  List<Map<String, dynamic>> treatments = [];
  late TextEditingController searchController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _loadData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> result =
          await DatabaseHelper.instance.getTreatments();
      setState(() {
        treatments = result.reversed.toList();
      });
    } catch (e) {
      debugPrint('Error loading treatments: $e');
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
          return treatment.values.any((value) => value
              .toString()
              .toLowerCase()
              .contains(searchTerm.toLowerCase()));
        }).toList();
      }
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 'Invalid Date';
    }
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat("yyyy-MM-dd").format(date);
    } catch (e) {
      debugPrint('Invalid date format: $e');
      return 'Invalid Date';
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, int treatmentId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this treatment?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await DatabaseHelper.instance.deleteTreatment(treatmentId);
                _loadData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddTreatmentPage() async {
    final addedTreatment = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTreatmentPage(
          onAdd: (newTreatment) => _addTreatment(newTreatment),
          onNewFieldRequested: () {
            // Handle new field request logic here
          },
        ),
      ),
    );
    if (addedTreatment != null) {
      _loadData();
    }
  }

  void _addTreatment(Map<String, dynamic> newTreatment) async {
    newTreatment['status'] = DateFormat("yyyy-MM-dd")
            .parse(newTreatment['date'])
            .isBefore(DateTime.now())
        ? 'Done'
        : 'Planned';
    await DatabaseHelper.instance.insertTreatments(newTreatment);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                onChanged: (value) => _applySearchFilter(value),
                decoration: const InputDecoration(
                  hintText: 'Search by name, type, or date',
                  border: InputBorder.none,
                ),
              )
            : const Text('Treatments'),
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
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              await PDFGenerator.generateAndShareTreatmentPdf(
                  context, treatments);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: treatments.length,
        itemBuilder: (context, index) {
          var treatment = treatments[index];
          String formattedDate = _formatDate(treatment["date"]);
          String status = treatment['status'];
          Color statusColor = status == 'Done' ? Colors.green : Colors.yellow;

          return Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        treatment["treatment_type"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
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
                                  _loadData();
                                }
                              });
                            } else if (value == 'delete') {
                              _showDeleteConfirmationDialog(
                                  context, treatment['id']);
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
                    ],
                  ),
                  const Divider(thickness: 0.5, color: Colors.black54),
                  const SizedBox(height: 8),
                  TreatmentItem(label: 'Treatment date', value: formattedDate),
                  TreatmentItem(
                      label: 'Status', value: '$status', color: statusColor),
                  TreatmentItem(
                      label: 'Treatment type',
                      value: treatment["treatment_type"]),
                  TreatmentItem(label: 'Field name', value: treatment["field"]),
                  TreatmentItem(
                      label: 'Product used', value: treatment["product_used"]),
                  TreatmentItem(
                      label: 'Quantity',
                      value: treatment["quantity"].toString()),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTreatmentPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TreatmentItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const TreatmentItem({
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
          Text(label),
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
