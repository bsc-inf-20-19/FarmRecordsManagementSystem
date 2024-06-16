import 'package:farm_records_management_system/plant/new_planting.dart';
import 'package:flutter/material.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';

class PlantingRecordsPage extends StatefulWidget {
  @override
  _PlantingRecordsPageState createState() => _PlantingRecordsPageState();
}

class _PlantingRecordsPageState extends State<PlantingRecordsPage> {
  List<Map<String, dynamic>> _plantings = [];

  @override
  void initState() {
    super.initState();
    _fetchPlantings();
  }

  Future<void> _fetchPlantings() async {
    final plantings = await DatabaseHelper.instance.getPlantings();
    setState(() {
      _plantings = plantings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Planting Records',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: _plantings.isEmpty
          ? const Center(
              child: Text('No planting records found.'),
            )
          : ListView.builder(
              itemCount: _plantings.length,
              itemBuilder: (context, index) {
                final planting = _plantings[index];
                return ListTile(
                  title: Text(planting['crop']),
                  subtitle: Text('Field: ${planting['field']}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPlantPage()),
          );

          if (result == true) {
            _fetchPlantings(); // Refresh the plantings after adding a new one
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
