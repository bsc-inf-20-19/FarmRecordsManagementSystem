import 'package:farm_records_management_system/screens/new_crop_page.dart';
import 'package:flutter/material.dart';
import 'databaseHelper.dart';

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
    final crops = await DatabaseHelper.getCrops();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crops'),
        centerTitle: true,
      ),
      body: _buildCropList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCropPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCropList() {
    if (_crops.isEmpty) {
      return const Center(
        child: Text('No crops available'),
      );
    }

    return ListView.builder(
      itemCount: _crops.length,
      itemBuilder: (context, index) {
        final crop = _crops[index];
        return ListTile(
          title: Text(crop['name']),
          subtitle: Text('Harvest Units: ${crop['harvestUnits']}\nNotes: ${crop['notes']}'),
        );
      },
    );
  }
}
