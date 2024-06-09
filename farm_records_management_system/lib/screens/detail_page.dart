import 'package:farm_records_management_system/screens/databaseHelper.dart';
import 'package:farm_records_management_system/screens/new_planting.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class Details extends StatefulWidget {
  const Details({
    super.key,
    required this.cropCompany,
    required this.cropType,
    required this.cropLotNumber,
    required this.cropHarvest,
  });

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

  Future<void> _deletePlanting(int id) async {
    await DatabaseHelper.deletePlanting(id);
    _fetchPlantings(); // Refresh the list after deletion
  }

  Future<void> _editPlanting(Map<String, dynamic> planting) async {
    // Navigate to a new page with a form to edit the planting details
    // After editing, refresh the list
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlantingPage(planting: planting),
      ),
    ).then((_) => _fetchPlantings());
  }

  Future<void> _exportToPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.ListView.builder(
              itemCount: _plantings.length,
              itemBuilder: (context, index) {
                final planting = _plantings[index];
                return pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Crop: ${planting['crop'] ?? 'N/A'}', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      pw.Text('Field: ${planting['field'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('Seed Quantity: ${planting['description'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('Seed Company: ${planting['cropCompany'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('Seed Type: ${planting['cropType'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('Seed Lot Number: ${planting['cropLotNumber'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('Estimated Harvest: ${planting['cropHarvest'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('Date: ${planting['date'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                      pw.Divider(),
                    ],
                  ),
                );
              },
            ),
          ];
        },
      ),
    );

    final directory = await getExternalStorageDirectory();
    final path = directory?.path;
    final file = File('$path/plantings.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF exported to ${file.path}')),
    );

    await OpenFile.open(file.path);
  }

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    sheetObject.appendRow([
      'Crop',
      'Field',
      'Seed Quantity',
      'Seed Company',
      'Seed Type',
      'Seed Lot Number',
      'Estimated Harvest',
      'Date',
    ]);

    for (final planting in _plantings) {
      sheetObject.appendRow([
        planting['crop'] ?? 'N/A',
        planting['field'] ?? 'N/A',
        planting['description'] ?? 'N/A',
        planting['cropCompany'] ?? 'N/A',
        planting['cropType'] ?? 'N/A',
        planting['cropLotNumber'] ?? 'N/A',
        planting['cropHarvest'] ?? 'N/A',
        planting['date'] ?? 'N/A',
      ]);
    }

    final directory = await getExternalStorageDirectory();
    final path = directory?.path;
    final file = File('$path/plantings.xlsx');
    await file.writeAsBytes(excel.encode()!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Excel exported to ${file.path}')),
    );

    await OpenFile.open(file.path);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportToPdf,
          ),
          IconButton(
            icon: const Icon(Icons.table_chart),
            onPressed: _exportToExcel,
          ),
        ],
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
                              Align(
                                alignment: Alignment.topRight,
                                child: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      _deletePlanting(planting['id']);
                                    } else if (value == 'edit') {
                                      _editPlanting(planting);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                planting['crop'] ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Field: ${planting['field'] ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Seed Quantity: ${planting['description'] ?? 'N/A'}',
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
                              const SizedBox(height: 10),
                              Text(
                                'Date: ${planting['date'] ?? 'N/A'}',
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
          ).then((_) => _fetchPlantings());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EditPlantingPage extends StatefulWidget {
  final Map<String, dynamic> planting;

  const EditPlantingPage({super.key, required this.planting});

  @override
  _EditPlantingPageState createState() => _EditPlantingPageState();
}

class _EditPlantingPageState extends State<EditPlantingPage> {
  late TextEditingController _dateController;
  late TextEditingController _cropController;
  late TextEditingController _fieldController;
  late TextEditingController _descriptionController;
  late TextEditingController _cropCompanyController;
  late TextEditingController _cropTypeController;
  late TextEditingController _cropLotNumberController;
  late TextEditingController _cropHarvestController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.planting['date']);
    _cropController = TextEditingController(text: widget.planting['crop']);
    _fieldController = TextEditingController(text: widget.planting['field']);
    _descriptionController = TextEditingController(text: widget.planting['description']);
    _cropCompanyController = TextEditingController(text: widget.planting['cropCompany']);
    _cropTypeController = TextEditingController(text: widget.planting['cropType']);
    _cropLotNumberController = TextEditingController(text: widget.planting['cropLotNumber']);
    _cropHarvestController = TextEditingController(text: widget.planting['cropHarvest']);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _cropController.dispose();
    _fieldController.dispose();
    _descriptionController.dispose();
    _cropCompanyController.dispose();
    _cropTypeController.dispose();
    _cropLotNumberController.dispose();
    _cropHarvestController.dispose();
    super.dispose();
  }

  Future<void> _updatePlanting() async {
    Map<String, dynamic> updatedPlanting = {
      'date': _dateController.text,
      'crop': _cropController.text,
      'field': _fieldController.text,
      'description': _descriptionController.text,
      'cropCompany': _cropCompanyController.text,
      'cropType': _cropTypeController.text,
      'cropLotNumber': _cropLotNumberController.text,
      'cropHarvest': _cropHarvestController.text,
    };

    await DatabaseHelper.updatePlanting(widget.planting['id'], updatedPlanting);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Planting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _cropController,
              decoration: const InputDecoration(labelText: 'Crop'),
            ),
            TextField(
              controller: _fieldController,
              decoration: const InputDecoration(labelText: 'Field'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Seed Quantity'),
            ),
            TextField(
              controller: _cropCompanyController,
              decoration: const InputDecoration(labelText: 'Seed Company'),
            ),
            TextField(
              controller: _cropTypeController,
              decoration: const InputDecoration(labelText: 'Seed Type'),
            ),
            TextField(
              controller: _cropLotNumberController,
              decoration: const InputDecoration(labelText: 'Seed Lot Number'),
            ),
            TextField(
              controller: _cropHarvestController,
              decoration: const InputDecoration(labelText: 'Estimated Harvest'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePlanting,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
