import 'dart:io';
import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/plant/new_planting.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:farm_records_management_system/screens/new_planting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class Details extends StatefulWidget {
  const Details({
    Key? key,
    required this.cropName,
    required this.cropCompany,
    required this.cropType,
    required this.cropPlotNumber,
    required this.cropHarvest,
    required this.seedType,
  }) : super(key: key);

  final String cropName;
  final String cropCompany;
  final String cropType;
  final String cropPlotNumber;
  final String cropHarvest;
  final String seedType;

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
    // DateTime selectedDate = DateTime.now();
    // DateTime endDate = DateTime.now().add(const Duration(days: 30));

    List<Map<String, dynamic>> plantings = await DatabaseHelper.instance.getPlantings();

    if (widget.cropName.isNotEmpty) {
      plantings = plantings
          .where((planting) =>
              (planting['crop'] ?? '').toLowerCase() ==
              widget.cropName.toLowerCase())
          .toList();
    }

    // Create a copy of the list before sorting
    List<Map<String, dynamic>> sortedPlantings =
        List<Map<String, dynamic>>.from(plantings);

    // Sort plantings by date in descending order
    sortedPlantings.sort((a, b) {
      DateTime dateA;
      DateTime dateB;

      try {
        dateA = DateTime.parse(a['date']);
      } catch (e) {
        dateA = DateTime(1970); // Default to Unix epoch if parsing fails
      }

      try {
        dateB = DateTime.parse(b['date']);
      } catch (e) {
        dateB = DateTime(1970); // Default to Unix epoch if parsing fails
      }

      return dateB.compareTo(dateA);
    });

    setState(() {
      _plantings = sortedPlantings;
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

  Future<void> _requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // Permission granted, do nothing
    } else {
      // Permission denied, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission is required to save files')),
      );
    }
  }

  Future<void> _exportToPdf() async {
    await _requestPermissions();

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.ListView.builder(
            itemCount: _plantings.length,
            itemBuilder: (context, index) {
              final planting = _plantings[index];
              return pw.Container(
                padding: pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Crop: ${planting['crop'] ?? 'N/A'}'),
                    pw.Text('Field: ${planting['field'] ?? 'N/A'}'),
                    pw.Text('Seed Quantity: ${planting['description'] ?? 'N/A'}'),
                    pw.Text('Seed Company: ${planting['cropCompany'] ?? 'N/A'}'),
                    pw.Text('Seed Type: ${planting['cropType'] ?? 'N/A'}'),
                    pw.Text('Seed Plot Number: ${planting['cropPlotNumber'] ?? 'N/A'}'),
                    pw.Text('Estimated Harvest: ${planting['cropHarvest'] ?? 'N/A'}'),
                    pw.Text('Date: ${planting['date'] ?? 'N/A'}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );

    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accessing external storage')),
      );
      return;
    }

    final path = directory.path;
    final pdfFile = File('$path/plantings.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF exported to ${pdfFile.path}')),
    );

    await OpenFile.open(pdfFile.path);
  }

  Future<void> _exportToCsv() async {
    await _requestPermissions();

    List<List<dynamic>> csvData = [];

    // Header row
    csvData.add([
      'Crop',
      'Field',
      'Seed Quantity',
      'Seed Company',
      'Seed Type',
      'Seed Plot Number',
      'Estimated Harvest',
      'Date',
    ]);

    // Data rows
    _plantings.forEach((planting) {
      csvData.add([
        planting['crop'] ?? 'N/A',
        planting['field'] ?? 'N/A',
        planting['description'] ?? 'N/A',
        planting['cropCompany'] ?? 'N/A',
        planting['cropType'] ?? 'N/A',
        planting['cropPlotNumber'] ?? 'N/A',
        planting['cropHarvest'] ?? 'N/A',
        planting['date'] ?? 'N/A',
      ]);
    });

    // Convert data to List<List<String>> as csv package expects List<dynamic>
    List<List<String>> csvDataAsString =
        csvData.map((row) => row.map((e) => e.toString()).toList()).toList();

    // Get external storage directory
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      // Handle error: Unable to access external storage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accessing external storage')),
      );
      return;
    }

    // Create a File instance for the CSV file
    final path = directory.path;
    final csvFile = File('$path/plantings.csv');

    // Convert data to CSV format and write to file
    String csvContent = const ListToCsvConverter().convert(csvDataAsString);
    await csvFile.writeAsString(csvContent);

    // Show SnackBar after export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('CSV exported to ${csvFile.path}')),
    );

    // Open the exported CSV file using a file viewer
    await OpenFile.open(csvFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plantings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportToPdf,
            tooltip: 'Export to PDF',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportToCsv,
            tooltip: 'Export to CSV',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: _plantings.length,
        itemBuilder: (context, index) {
          final planting = _plantings[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.seedling,
                  color: Colors.green.shade700, size: 30),
              title: Text(
                planting['crop'] ?? 'N/A',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    'Field: ${planting['field'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Seed Quantity: ${planting['description'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Seed Company: ${planting['cropCompany'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Seed Type: ${planting['cropType'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Seed Plot Number: ${planting['cropPlotNumber'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Estimated Harvest: ${planting['cropHarvest'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Date: ${planting['date'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black87),
                    onPressed: () => _editPlanting(planting),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black87),
                    onPressed: () => _deletePlanting(planting['id']),
                  ),
                ],
              ),
              onTap: () {
                _updateCropList(planting['crop'] ?? 'N/A');
                _editPlanting(planting);
              },
              onLongPress: () => _deletePlanting(planting['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Details(cropName: '', cropCompany: '', cropType: '', cropPlotNumber: '', cropHarvest: '', seedType: '',),
            ),
          ).then((_) => _fetchPlantings());
        },
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _updateCropList {
  _updateCropList(param0);
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
    await _updateCropList(_cropController.text);
    Navigator.pop(context);
  }

  Future<void> _updateCropList(String cropName) async {
    List<Map<String, dynamic>> crops = await DatabaseHelper.instance.getCrops();
    bool cropExists = crops.any((crop) => crop['name'].toString().toLowerCase() == cropName.toLowerCase());

    if (!cropExists) {
      await DatabaseHelper.instance.insertCrop({'name': cropName, 'harvestUnits': '', 'notes': ''});
    }
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
                prefixIcon: Icon(FontAwesomeIcons.seedling),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fieldController,
              decoration: const InputDecoration(
                labelText: 'Field',
                border: OutlineInputBorder(),
                prefixIcon: Icon(FontAwesomeIcons.tractor),
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
                prefixIcon: Icon(FontAwesomeIcons.building),
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
                prefixIcon: Icon(FontAwesomeIcons.listOl),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cropHarvestController,
              decoration: const InputDecoration(
                labelText: 'Estimated Harvest',
                border: OutlineInputBorder(),
                prefixIcon: Icon(FontAwesomeIcons.calendarAlt),
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
