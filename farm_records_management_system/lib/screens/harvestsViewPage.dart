import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/screens/add_harvest_page.dart';
import 'package:farm_records_management_system/screens/update_harvest_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HarvestViewPage extends StatefulWidget {
  const HarvestViewPage({Key? key}) : super(key: key);

  @override
  _HarvestViewPageState createState() => _HarvestViewPageState();
}

class _HarvestViewPageState extends State<HarvestViewPage> {
  List<Map<String, dynamic>> harvests = [];
  late TextEditingController searchController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> result = await DatabaseHelper.instance.getHarvests();
      setState(() {
        harvests = result.reversed.toList();
      });
    } catch (e) {
      debugPrint('Error loading harvests: $e');
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
          return harvest['cropList'].toLowerCase().contains(searchTerm) ||
              harvest['batchNo'].toLowerCase().contains(searchTerm) ||
              harvest['harvestQuantity'].toLowerCase().contains(searchTerm) ||
              harvest['harvestQuality'].toLowerCase().contains(searchTerm) ||
              harvest['date'].toLowerCase().contains(searchTerm);
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

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int harvestId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this harvest?'),
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
                await DatabaseHelper.instance.deleteHarvest(harvestId);
                _loadData();
                Navigator.of(context).pop();
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
                  hintText: 'Search by crop, batch, or date',
                  border: InputBorder.none,
                ),
              )
            : Text('Harvests'),
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
        itemCount: harvests.length,
        itemBuilder: (context, index) {
          var harvest = harvests[index];
          String formattedDate = _formatDate(harvest["date"]);
          String harvestQuality = harvest['harvestQuality'];

          return Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${harvest["cropList"]}',
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
                                    harvestId: harvest['id'],
                                  ),
                                ),
                              ).then((result) {
                                if (result == true) {
                                  _loadData();
                                }
                              });
                            } else if (value == 'delete') {
                              _showDeleteConfirmationDialog(context, harvest['id']);
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
                  Divider(thickness: .5, color: Colors.black54),
                  SizedBox(height: 8),
                  HarvestItem(label: 'Harvest date', value: '$formattedDate'),
                  HarvestItem(label: 'Harvest Quality', value: '${harvest["harvestQuality"]} - $formattedDate'),
                  HarvestItem(label: 'Batch No', value: '${harvest["batchNo"]}'),
                  HarvestItem(label: 'Harvest Quantity', value: ' ${harvest["harvestQuantity"]}'),
                  HarvestItem(label: 'Unit Cost', value: '${harvest["unitCost"]}'),
                  HarvestItem(label: 'Harvest Income', value: '${harvest["harvestIncome"]}'),
                  HarvestItem(label: 'Harvest Notes', value: '${harvest["harvestNotes"]}'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final addedHarvest = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHarvestPage(),
            ),
          );
          if (addedHarvest != null) {
            _loadData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
