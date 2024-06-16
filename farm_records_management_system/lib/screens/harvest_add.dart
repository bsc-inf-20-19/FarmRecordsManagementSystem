import 'package:farm_records_management_system/screens/add_harvest_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';

class HarvestListScreen extends StatefulWidget {
  @override
  _HarvestListScreenState createState() => _HarvestListScreenState();
}

class _HarvestListScreenState extends State<HarvestListScreen> {
  List<Map<String, dynamic>> harvests = [];
  late TextEditingController searchController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _loadHarvests();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHarvests() async {
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
        _loadHarvests();
      } else {
        isSearching = true;
        harvests = harvests.where((harvest) {
          return harvest.values.any((value) =>
              value.toString().toLowerCase().contains(searchTerm.toLowerCase()));
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
                _loadHarvests();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddHarvestPage() async {
    final addedHarvest = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddHarvestPage(),
      ),
    );
    if (addedHarvest != null) {
      _loadHarvests();
    }
  }

  void _navigateToEditHarvestPage(int harvestId) async {
    final updatedHarvest = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddHarvestPage(),
      ),
    );
    if (updatedHarvest != null) {
      _loadHarvests();
    }
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
                  hintText: 'Search by crop, batch, or date',
                  border: InputBorder.none,
                ),
              )
            : const Text('Harvest List'),
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
          final harvest = harvests[index];
          final crop = harvest['cropList'] ?? 'N/A';
          final batchNo = harvest['batchNo'] ?? 'N/A';
          final quantity = harvest['harvestQuantity'] ?? 'N/A';
          final quality = harvest['harvestQuality'] ?? 'N/A';
          final unitCost = harvest['unitCost'] ?? 'N/A';
          final income = harvest['harvestIncome'] ?? 'N/A';
          final notes = harvest['harvestNotes'] ?? 'N/A';
          final date = harvest['date'] ?? 'N/A';

          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        crop,
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
                              _navigateToEditHarvestPage(harvest['id']);
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
                  const Divider(thickness: 0.5, color: Colors.black54),
                  const SizedBox(height: 8),
                  HarvestItem(label: 'Batch No', value: batchNo, color: Colors.green),
                  HarvestItem(label: 'Quantity', value: quantity, color: Colors.blue),
                  HarvestItem(label: 'Quality', value: quality, color: Colors.orange),
                  HarvestItem(label: 'Unit Cost', value: unitCost, color: Colors.red),
                  HarvestItem(label: 'Income', value: income, color: Colors.purple),
                  HarvestItem(label: 'Date', value: _formatDate(date), color: Colors.brown),
                  HarvestItem(label: 'Notes', value: notes, color: Colors.cyan),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddHarvestPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HarvestItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const HarvestItem({
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
