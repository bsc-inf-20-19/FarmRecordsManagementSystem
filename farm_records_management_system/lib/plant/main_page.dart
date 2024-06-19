import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/plant/new_planting.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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

  void _navigateToNewPlantPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPlantPage()),
    );

    if (result == true) {
      _fetchPlantings(); // Refresh the plantings after adding a new one
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planting Records', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: _plantings.isEmpty
          ? const Center(
              child: Text(
                'No plantings found',
                style: TextStyle(color: Colors.orange, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _plantings.length,
              itemBuilder: (context, index) {
                final planting = _plantings[index];
                return Card(
                  color: const Color(0xFFC7C7C7),
                  margin: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow('Date:', planting['date']),
                        _buildRow('Field:', planting['field']),
                        _buildRow('Description:', planting['description']),
                        _buildRow('Crop Company:', planting['cropCompany']),
                        _buildRow('Crop Type:', planting['cropType']),
                        _buildRow('Plot Number:', planting['cropPlotNumber']),
                        _buildRow('Estimated Harvest:', planting['cropHarvest']),
                        _buildRow('Seed Type:', planting['seedType']),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewPlantPage,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
