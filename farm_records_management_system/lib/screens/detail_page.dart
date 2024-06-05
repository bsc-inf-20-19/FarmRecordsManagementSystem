import 'package:farm_records_management_system/screens/databaseHelper.dart';
import 'package:farm_records_management_system/screens/new_planting.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  const Details({
    Key? key,
    // required this.cropList,
    // required this.fieldList,
    // required this.cropDescription,
    required this.cropCompany,
    required this.cropType,
    required this.cropLotNumber,
    required this.cropHarvest,
  }) : super(key: key);

  // final String cropList;
  // final String fieldList;
  //final String cropDescription;
  final String cropCompany;
  final String cropType;
  final String cropLotNumber;
  final String cropHarvest;

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<Map<String, dynamic>> _plantings = [];

  @override
  void initState() {
    super.initState();
    _fetchPlantings();
  }

  Future<void> _fetchPlantings() async {
    List<Map<String, dynamic>> plantings = await DatabaseHelper.getPlantings();
    setState(() {
      _plantings = plantings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Details'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _plantings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _plantings.length,
              itemBuilder: (context, index) {
                final planting = _plantings[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topRight,
                                child: Icon(Icons.more_vert),
                              ),
                              Text(
                                planting['cropList'] ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Field: ${planting['fieldList'] ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Seed Quantity: ${planting['cropDescription'] ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Seed Company: ${planting['cropCompany'] ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Seed Type: ${planting['cropType'] ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Seed Lot Number: ${planting['cropLotNumber'] ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Estimated Harvest: ${planting['cropHarvest'] ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPlantPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
