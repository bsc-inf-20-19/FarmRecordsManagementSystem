import 'package:farm_records_management_system/home/screens/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateTreatmentPage extends StatefulWidget {
  final int treatmentId;

  const UpdateTreatmentPage({super.key, required this.treatmentId});

  @override
  _UpdateTreatmentPageState createState() => _UpdateTreatmentPageState();
}

class _UpdateTreatmentPageState extends State<UpdateTreatmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _productUsedController = TextEditingController();
  final _quantityController = TextEditingController();
  String? _selectedStatus;
  String? _selectedTreatmentType;
  String? _selectedField;
  DateTime? _selectedDate;

  void fetchTreatment() async {
    Map<String, dynamic>? treatmentData =
        await DatabaseHelper.getTreatment(widget.treatmentId);

    if (treatmentData != null) {
      setState(() {
        _selectedDate = DateTime.parse(treatmentData['date']);
        _selectedStatus = treatmentData['status'];
        _selectedTreatmentType = treatmentData['treatment_type'];
        _selectedField = treatmentData['field'];
        _productUsedController.text = treatmentData['product_used'];
        _quantityController.text = treatmentData['quantity'].toString();
      });
    }
  }

  @override
  void initState() {
    fetchTreatment();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateTreatment(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedTreatment = {
        'date': DateFormat("yyyy-MM-dd").format(_selectedDate!),
        'status': _selectedStatus,
        'treatment_type': _selectedTreatmentType,
        'field': _selectedField,
        'product_used': _productUsedController.text,
        'quantity': double.tryParse(_quantityController.text),
      };

      await DatabaseHelper.updateTreatment(
          widget.treatmentId, updatedTreatment);
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _productUsedController.text = '';
    _quantityController.text = '';

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Treatment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        : 'Select Date',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: ['Planned', 'Done'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _selectedStatus = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedTreatmentType,
                items: [
                  'Fertilizer',
                  'Fungicide',
                  'Herbicide',
                  'Insecticide',
                  'Nutrients',
                  'Other',
                ].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Treatment Type',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _selectedTreatmentType = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a treatment type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _productUsedController,
                decoration: const InputDecoration(
                  labelText: 'Product Used',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product used';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity of Product',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _updateTreatment(context);
                },
                child: const Text('Update Treatment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
