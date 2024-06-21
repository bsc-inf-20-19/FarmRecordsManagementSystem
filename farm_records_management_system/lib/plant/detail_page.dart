import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/plant/edit_planting.dart';
import 'package:farm_records_management_system/plant/new_planting.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

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
    List<Map<String, dynamic>> plantings =
        await DatabaseHelper.instance.getPlantings();
    if (widget.cropName.isNotEmpty) {
      plantings = plantings
          .where((planting) =>
              (planting['crop'] ?? '').toLowerCase() ==
              widget.cropName.toLowerCase())
          .toList();
    }

    List<Map<String, dynamic>> sortedPlantings =
        List<Map<String, dynamic>>.from(plantings);
    sortedPlantings.sort((a, b) {
      DateTime dateA;
      DateTime dateB;

      try {
        dateA = DateTime.parse(a['date']);
      } catch (e) {
        dateA = DateTime(1970);
      }

      try {
        dateB = DateTime.parse(b['date']);
      } catch (e) {
        dateB = DateTime(1970);
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

  Future<void> _navigateToNewPlantingPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPlantPage(),
      ),
    ).then((_) => _fetchPlantings());
  }

  Future<void> _requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission is required to save files')),
      );
    }
  }

  Future<void> _exportToPdf() async {
    await _requestPermissions();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => _plantings.map((planting) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Text('Crop: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(planting['crop'] ?? 'N/A'),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Text('Field: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(planting['field'] ?? 'N/A'),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Text('Seed Quantity: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(planting['description'] ?? 'N/A'),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Text('Seed Company: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(planting['cropCompany'] ?? 'N/A'),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Text('Seed Type: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(planting['cropType'] ?? 'N/A'),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Text('Seed Plot Number: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(planting['cropPlotNumber'] ?? 'N/A'),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Text('Estimated Harvest: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(planting['cropHarvest'] ?? 'N/A'),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Text('Date: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(planting['date'] ?? 'N/A'),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );

    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error accessing external storage')),
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

    List<List<dynamic>> csvData = [
      [
        'Crop',
        'Field',
        'Seed Quantity',
        'Seed Company',
        'Seed Type',
        'Seed Plot Number',
        'Estimated Harvest',
        'Date',
      ]
    ];

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

    List<List<String>> csvDataAsString =
        csvData.map((row) => row.map((e) => e.toString()).toList()).toList();

    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accessing external storage')),
      );
      return;
    }

    final path = directory.path;
    final csvFile = File('$path/plantings.csv');
    String csvContent = const ListToCsvConverter().convert(csvDataAsString);
    await csvFile.writeAsString(csvContent);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('CSV exported to ${csvFile.path}')),
    );

    await OpenFile.open(csvFile.path);
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

    _fetchPlantings();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV data imported successfully')),
    );
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
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: _importCsv,
            tooltip: 'Import CSV',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: _plantings.length,
        itemBuilder: (context, index) {
          final planting = _plantings[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10.0),
              title: Text(
                planting['crop'] ?? 'N/A',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        'Field: ${planting['field'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.inventory, size: 18, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        'Seed Quantity: ${planting['description'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.building, size: 18, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        'Seed Company: ${planting['cropCompany'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.eco, size: 18, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        'Seed Type: ${planting['cropType'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.numbers, size: 18, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        'Seed Plot Number: ${planting['cropPlotNumber'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        'Estimated Harvest: ${planting['cropHarvest'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.date_range, size: 18, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        'Date: ${planting['date'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _editPlanting(planting);
                  } else if (value == 'delete') {
                    _deletePlanting(planting['id']);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ];
                },
              ),
              isThreeLine: true,
              onTap: () {
                // Display full details if required
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewPlantingPage,
        child: const Icon(Icons.add),
        backgroundColor: Colors.green.shade700,
        tooltip: 'Add New Planting',
      ),
    );
  }
}
