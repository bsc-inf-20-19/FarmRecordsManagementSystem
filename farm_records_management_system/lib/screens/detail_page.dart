import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/screens/new_planting.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class Details extends StatefulWidget {
  const Details({
    Key? key,
    required this.cropCompany,
    required this.cropType,
    required this.cropLotNumber,
    required this.cropHarvest, required cropName, required String cropPlotNumber, required String seedType,
  }) : super(key: key);

  final String cropCompany;
  final String cropType;
  final String cropPlotNumber;
  final String cropHarvest;

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<Map<String, dynamic>> _plantings = [];
  String _cropFilter = '';
  List<String> _cropSuggestions = [];

  @override
  void initState() {
    super.initState();
    _fetchPlantings();
    _fetchCropSuggestions();
  }

  Future<void> _fetchPlantings() async {
    DateTime selectedDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 30));

    List<Map<String, dynamic>> plantings = await DatabaseHelper.instance.getPlantings(selectedDate, endDate: null, startDate: null);

    if (_cropFilter.isNotEmpty) {
      plantings = plantings.where((planting) => (planting['crop'] ?? '').toLowerCase().contains(_cropFilter.toLowerCase())).toList();
    }

    setState(() {
      _plantings = plantings;
    });
  }

  Future<void> _fetchCropSuggestions() async {
    // Fetch crop names from the database
    List<String> cropSuggestions = await DatabaseHelper.instance.getCropSuggestions();
    setState(() {
      _cropSuggestions = cropSuggestions;
    });
  }

  Future<void> _deletePlanting(int id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await DatabaseHelper.instance.deletePlanting(id);
      _fetchPlantings();
    }
  }

  Future<void> _editPlanting(Map<String, dynamic> planting) async {
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
                      pw.Text(
                        'Crop: ${planting['crop'] ?? 'N/A'}',
                        style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text('Field: ${planting['field'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('Seed Quantity: ${planting['description'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('Seed Company: ${planting['cropCompany'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('Seed Type: ${planting['cropType'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('Seed Plot Number: ${planting['cropPlotNumber'] ?? 'N/A'}', style: const pw.TextStyle(fontSize: 16)),
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
      'Seed Plot Number',
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
        planting['cropPlotNumber'] ?? 'N/A',
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
            icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
            onPressed: _exportToPdf,
            tooltip: 'Export to PDF',
          ),
          IconButton(
            icon: const Icon(Icons.table_chart, color: Colors.blueAccent),
            onPressed: _exportToExcel,
            tooltip: 'Export to Excel',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _cropSuggestions.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                setState(() {
                  _cropFilter = selection;
                  _fetchPlantings();
                });
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Filter by Crop Name',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _cropFilter = value;
                      _fetchPlantings();
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
            child: _plantings.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _plantings.length,
                    itemBuilder: (context, index) {
                      final planting = _plantings[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    planting['crop'] ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _editPlanting(planting),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => _deletePlanting(planting['id']),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _buildDetailRow('Field', planting['field'], Icons.landscape),
                              _buildDetailRow('Seed Quantity', planting['description'], Icons.production_quantity_limits),
                              _buildDetailRow('Seed Company', planting['cropCompany'], Icons.business),
                              _buildDetailRow('Seed Type', planting['cropType'], Icons.grass),
                              _buildDetailRow('Seed Plot Number', planting['cropPlotNumber'], Icons.confirmation_number),
                              _buildDetailRow('Estimated Harvest', planting['cropHarvest'], Icons.eco),
                              _buildDetailRow('Date', planting['date'], Icons.date_range),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPlantPage()),
          ).then((_) => _fetchPlantings());
        },
        child: const Icon(Icons.add, size: 32),
        backgroundColor: Colors.green,
        tooltip: 'Add New Planting',
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value ?? 'N/A',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class EditPlantingPage extends StatefulWidget {
  final Map<String, dynamic> planting;

  const EditPlantingPage({Key? key, required this.planting}) : super(key: key);

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
  late TextEditingController _cropPlotNumberController;
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
    _cropPlotNumberController = TextEditingController(text: widget.planting['cropPlotNumber']);
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
    _cropPlotNumberController.dispose();
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
      'cropPlotNumber': _cropPlotNumberController.text,
      'cropHarvest': _cropHarvestController.text,
    };

    await DatabaseHelper.instance.updatePlanting(widget.planting['id'], updatedPlanting);
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
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.date_range),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cropController,
              decoration: const InputDecoration(
                labelText: 'Crop',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.grass),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fieldController,
              decoration: const InputDecoration(
                labelText: 'Field',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.landscape),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Seed Quantity',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.production_quantity_limits),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cropCompanyController,
              decoration: const InputDecoration(
                labelText: 'Seed Company',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cropTypeController,
              decoration: const InputDecoration(
                labelText: 'Seed Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cropPlotNumberController,
              decoration: const InputDecoration(
                labelText: 'Seed Plot Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.confirmation_number),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cropHarvestController,
              decoration: const InputDecoration(
                labelText: 'Estimated Harvest',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.eco),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePlanting,
              child: const Text('Save'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
