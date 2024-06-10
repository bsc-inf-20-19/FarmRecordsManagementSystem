import 'dart:convert';

import 'package:farm_records_management_system/screens/databaseHelper.dart';
import 'package:farm_records_management_system/screens/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';

class NewPlantPage extends StatefulWidget {
  const NewPlantPage({super.key});

  @override
  _NewPlantPageState createState() => _NewPlantPageState();
}

class _NewPlantPageState extends State<NewPlantPage> {
  DateTime? _selectedDate;

  // Function to show the date picker and set the selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    // If the user picked a date, set the selected date state
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  _NewPlantPageState() {
    _cropDropdownController.text = _cropTypeList[0];
    _fieldDropdownController.text = _fieldList[0];
  }

  final _cropDecController = TextEditingController();
  final _cropCompanyController = TextEditingController();
  final _cropTypeController = TextEditingController();
  final _cropPlotController = TextEditingController();
  final _cropHarvestController = TextEditingController();

  final List<String> _cropTypeList = ["Maize", "Tobacco", "G. Nuts", "Beans"];
  final _cropDropdownController = TextEditingController();

  final List<String> _fieldList = [
    "M01 Field",
    "T01 Field",
    "G01 Field",
    "B01 Field"
  ];
  final _fieldDropdownController = TextEditingController();

  @override
  void dispose() {
    _cropDecController.dispose();
    _cropCompanyController.dispose();
    _cropTypeController.dispose();
    _cropPlotController.dispose();
    _cropHarvestController.dispose();
    _cropDropdownController.dispose();
    _fieldDropdownController.dispose();
    super.dispose();
  }

  Future<void> _importFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      if (result.files.single.extension == 'csv') {
        final input = file.openRead();
        final fields = await input.transform(utf8.decoder).transform(CsvToListConverter()).toList();

        for (var row in fields) {
          Map<String, dynamic> plantingData = {
            'date': row[0],
            'crop': row[1],
            'field': row[2],
            'description': row[3],
            'cropCompany': row[4],
            'cropType': row[5],
            'cropPlotNumber': row[6],
            'cropHarvest': row[7],
          };
          await DatabaseHelper.insertPlanting(plantingData);
        }
      } else if (result.files.single.extension == 'xlsx') {
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table];
          for (var row in sheet!.rows) {
            Map<String, dynamic> plantingData = {
              'date': row[0]?.value,
              'crop': row[1]?.value,
              'field': row[2]?.value,
              'description': row[3]?.value,
              'cropCompany': row[4]?.value,
              'cropType': row[5]?.value,
              'cropPlotNumber': row[6]?.value,
              'cropHarvest': row[7]?.value,
            };
            await DatabaseHelper.insertPlanting(plantingData);
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data imported successfully')),
      );
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Planting'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: _importFromFile,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Select a date',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
              ),
              controller: TextEditingController(
                text: _selectedDate != null
                    ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                    : '',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10.0),

            // DropDown crop name and field
            DropdownButtonFormField(
              value: _cropDropdownController.text,
              items: _cropTypeList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _cropDropdownController.text = val as String;
                });
              },
              icon: const Icon(Icons.arrow_drop_down_outlined),
              decoration: const InputDecoration(
                  labelText: "Select crop", border: UnderlineInputBorder()),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField(
              value: _fieldDropdownController.text,
              items: _fieldList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _fieldDropdownController.text = val as String;
                });
              },
              icon: const Icon(Icons.arrow_drop_down_outlined),
              decoration: const InputDecoration(
                  labelText: "Select field", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10.0),

            // Textfields for seeds information
            MyTextField(
              myController: _cropDecController,
              fieldName: "Seed quantity",
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropCompanyController,
              fieldName: "Seed company",
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropTypeController,
              fieldName: "Seed type",
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropPlotController,
              fieldName: "Seed plot number",
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropHarvestController,
              fieldName: "Estimated harvest",
            ),
            const SizedBox(height: 10.0),
            myBtn(context),
          ],
        ),
      ),
    );
  }

  OutlinedButton myBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
      onPressed: () async {
        // Create a map to hold the data
        Map<String, dynamic> plantingData = {
          'date': _selectedDate != null ? '${_selectedDate!.toLocal()}'.split(' ')[0] : '',
          'crop': _cropDropdownController.text,
          'field': _fieldDropdownController.text,
          'description': _cropDecController.text,
          'cropCompany': _cropCompanyController.text,
          'cropType': _cropTypeController.text,
          'cropPlotNumber': _cropPlotController.text,
          'cropHarvest': _cropHarvestController.text,
        };

        // Insert data into the database
        await DatabaseHelper.insertPlanting(plantingData);

        // Navigate to the Details page and pass the data
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Details(
              cropCompany: _cropCompanyController.text,
              cropType: _cropTypeController.text,
              cropPlotNumber: _cropPlotController.text,
              cropHarvest: _cropHarvestController.text,
            );
          }),
        );
      },
      child: const Text("Add"),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.myController,
    required this.fieldName,
    this.myIcon = Icons.verified_user_outlined,
    this.prefixIconColor = Colors.blueAccent,
  });

  final TextEditingController myController;
  final String fieldName;
  final IconData myIcon;
  final Color prefixIconColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      decoration: InputDecoration(
        labelText: fieldName,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade300),
        ),
      ),
    );
  }
}
