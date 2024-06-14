import 'package:farm_records_management_system/home/screens/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateHarvestPage extends StatefulWidget {
  final int harvestId;

  const UpdateHarvestPage({required this.harvestId, Key? key}) : super(key: key);

  @override
  _UpdateHarvestPageState createState() => _UpdateHarvestPageState();
}

class _UpdateHarvestPageState extends State<UpdateHarvestPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _cropDropdownController;
  late TextEditingController _batchController;
  late TextEditingController _harvestQuantityController;
  late TextEditingController _harvestQualityController;
  late TextEditingController _unitCostController;
  late TextEditingController _harvestIncomeController;
  late TextEditingController _harvestNotesController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadHarvestData();
    _dateController = TextEditingController();
    _cropDropdownController = TextEditingController();
    _batchController = TextEditingController();
    _harvestQuantityController = TextEditingController();
    _harvestQualityController = TextEditingController();
    _unitCostController = TextEditingController();
    _harvestIncomeController = TextEditingController();
    _harvestNotesController = TextEditingController();
  }

  Future<void> _loadHarvestData() async {
    var harvest = await DatabaseHelper.instance.getHarvest(widget.harvestId);
    if (harvest != null) {
      setState(() {
        _dateController.text = harvest['date'];
        _cropDropdownController.text = harvest['cropList'];
        _batchController.text = harvest['batchNo'];
        _harvestQuantityController.text = harvest['harvestQuantity'];
        _harvestQualityController.text = harvest['harvestQuality'];
        _unitCostController.text = harvest['unitCost'];
        _harvestIncomeController.text = harvest['harvestIncome'];
        _harvestNotesController.text = harvest['harvestNotes'];
        _selectedDate = DateTime.parse(harvest['date']);
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _cropDropdownController.dispose();
    _batchController.dispose();
    _harvestQuantityController.dispose();
    _harvestQualityController.dispose();
    _unitCostController.dispose();
    _harvestIncomeController.dispose();
    _harvestNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _updateHarvest() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedHarvest = {
        'id': widget.harvestId,
        'date': _dateController.text,
        'cropList': _cropDropdownController.text,
        'batchNo': _batchController.text,
        'harvestQuantity': _harvestQuantityController.text,
        'harvestQuality': _harvestQualityController.text,
        'unitCost': _unitCostController.text,
        'harvestIncome': _harvestIncomeController.text,
        'harvestNotes': _harvestNotesController.text,
      };
      await DatabaseHelper.instance.updateHarvest(widget.harvestId, updatedHarvest);
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Harvest'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cropDropdownController,
                decoration: InputDecoration(labelText: 'Crop'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter crop';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _batchController,
                decoration: InputDecoration(labelText: 'Batch No'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter batch number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _harvestQuantityController,
                decoration: InputDecoration(labelText: 'Harvest Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter harvest quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _harvestQualityController,
                decoration: InputDecoration(labelText: 'Harvest Quality'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter harvest quality';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitCostController,
                decoration: InputDecoration(labelText: 'Unit Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter unit cost';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _harvestIncomeController,
                decoration: InputDecoration(labelText: 'Harvest Income'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter harvest income';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _harvestNotesController,
                decoration: InputDecoration(labelText: 'Harvest Notes'),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter harvest notes';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateHarvest,
                child: Text('Update Harvest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
