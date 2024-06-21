import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/plant/crop_details_tabbed.dart';
import 'package:farm_records_management_system/plant/new_crop_page.dart';

class CropListPage extends StatefulWidget {
  const CropListPage({Key? key}) : super(key: key);

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
    final plantings = await DatabaseHelper.instance.getPlantings();

    Set existingCropNames = crops.map((crop) => crop['name'].toLowerCase()).toSet();
    Set newCropNames = plantings.map((planting) => planting['crop'].toLowerCase()).toSet();

    // Determine new crops that are not already in the crop list (case insensitive)
    Set uniqueNewCropNames = newCropNames.difference(existingCropNames);

    // Insert unique new crops into the database
    for (String newCropName in uniqueNewCropNames) {
      // Find the original case of the crop name
      String originalCaseName = plantings.firstWhere((planting) => planting['crop'].toLowerCase() == newCropName)['crop'];

      await DatabaseHelper.instance.insertCrop({
        'name': originalCaseName,
        'harvestUnits': '', // Set default values or leave blank as per your requirement
        'notes': '',        // Set default values or leave blank as per your requirement
      });
    }

    // Fetch updated crops list from the database
    final updatedCrops = await DatabaseHelper.instance.getCrops();
    setState(() {
      _crops = updatedCrops;
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
        builder: (context) => CropDetailsTabbedPage(crop: crop),
      ),
    ).then((_) => _fetchCrops());
  }

  Future<void> _importCsv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
      return;
    }

    File file = File(result.files.single.path!);

    final csvData = await file.readAsString();
    final List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);

    for (var i = 1; i < csvTable.length; i++) {
      final row = csvTable[i];
      await DatabaseHelper.instance.insertPlanting({
        'crop': row[0],
        'field': row[1],
        'description': row[2],
        'cropCompany': row[3],
        'cropType': row[4],
        'cropPlotNumber': row[5],
        'cropHarvest': row[6],
        'date': row[7],
      });
    }

    _fetchCrops(); // Fetch crops after importing to update the list

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV data imported successfully')),
    );
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
