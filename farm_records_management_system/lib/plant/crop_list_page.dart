import 'package:farm_records_management_system/plant/new_crop_page.dart';
import 'package:farm_records_management_system/screens/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';

class CropListPage extends StatefulWidget {
  const CropListPage({super.key});

  @override
  _CropListPageState createState() => _CropListPageState();
}

class _CropListPageState extends State<CropListPage> {
  List<Map<String, dynamic>> _crops = [];

  @override
  void initState() {
    super.initState();
    _fetchCrops();
  }

  Future<void> _fetchCrops() async {
    final crops = await DatabaseHelper.instance.getCrops();
    setState(() {
      _crops = crops;
    });
  }

  Future<void> _navigateToAddCropPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewCropPage()),
    );

    if (result == true) {
      _fetchCrops(); // Refresh the crop list after adding a new crop
    }
  }

  void _navigateToCropDetails(Map<String, dynamic> crop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Details(
          cropName: crop['name'], cropCompany: '', cropType: '', cropPlotNumber: '', cropHarvest: '', seedType: '',
        ),
      ),
    ).then((_) => _fetchCrops());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crops',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: _buildCropList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCropPage,
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCropList() {
    if (_crops.isEmpty) {
      return const Center(
        child: Text(
          'No crops available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: _crops.length,
      itemBuilder: (context, index) {
        final crop = _crops[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
            leading: Icon(Icons.eco, color: Colors.green.shade700, size: 30),
            title: Text(
              crop['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harvest Units: ${crop['harvestUnits']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  'Notes: ${crop['notes']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: Icon(Icons.chevron_right, color: Colors.green.shade700),
            onTap: () => _navigateToCropDetails(crop),
          ),
        );
      },
    );
  }
}
