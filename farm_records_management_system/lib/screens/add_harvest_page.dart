import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class AddHarvestPage extends StatefulWidget {
  @override
  _AddHarvestPageState createState() => _AddHarvestPageState();
}

class _AddHarvestPageState extends State<AddHarvestPage> {
  final TextEditingController _cropDropdownController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _harvestQuantityController = TextEditingController();
  final TextEditingController _harvestQualityController = TextEditingController();
  final TextEditingController _unitCostController = TextEditingController();
  final TextEditingController _harvestIncomeController = TextEditingController();
  final TextEditingController _harvestNotesController = TextEditingController();
  
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  void _saveHarvest() async {
    final Map<String, dynamic> harvest = {
      'date': _selectedDate != null ? '${_selectedDate!.toLocal()}'.split(' ')[0] : '',
      'cropList': _cropDropdownController.text,
      'batchNo': _batchController.text,
      'harvestQuantity': _harvestQuantityController.text,
      'harvestQuality': _harvestQualityController.text,
      'unitCost': _unitCostController.text,
      'harvestIncome': _harvestIncomeController.text,
      'harvestNotes': _harvestNotesController.text,
    };

    await DatabaseHelper.instance.insertHarvest(harvest);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Harvest'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _cropDropdownController,
              decoration: InputDecoration(labelText: 'Crop List'),
            ),
            TextFormField(
              controller: _batchController,
              decoration: InputDecoration(labelText: 'Batch No'),
            ),
            TextFormField(
              controller: _harvestQuantityController,
              decoration: InputDecoration(labelText: 'Harvest Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _harvestQualityController,
              decoration: InputDecoration(labelText: 'Harvest Quality'),
            ),
            TextFormField(
              controller: _unitCostController,
              decoration: InputDecoration(labelText: 'Unit Cost'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _harvestIncomeController,
              decoration: InputDecoration(labelText: 'Harvest Income'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _harvestNotesController,
              decoration: InputDecoration(labelText: 'Harvest Notes'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  _selectedDate != null
                      ? 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'
                      : 'No Date Chosen!',
                ),
                Spacer(),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Choose Date'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveHarvest,
              child: Text('Save Harvest'),
            ),
          ],
        ),
      ),
    );
  }
}
