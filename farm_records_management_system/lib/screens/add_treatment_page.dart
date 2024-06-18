import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/Pages/newField.dart';

class AddTreatmentPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  final VoidCallback onNewFieldRequested;

  const AddTreatmentPage({
    super.key,
    required this.onAdd,
    required this.onNewFieldRequested,
  });

  @override
  _AddTreatmentPageState createState() => _AddTreatmentPageState();
}

class _AddTreatmentPageState extends State<AddTreatmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _productUsedController = TextEditingController();
  final _quantityController = TextEditingController();
  final _customTreatmentTypeController = TextEditingController();
  String? _selectedStatus;
  String? _selectedTreatmentType;
  String? _selectedField;
  DateTime? _selectedDate;
  List<String> _existingFields = [];

  @override
  void initState() {
    super.initState();
    _loadFields();
  }

  Future<void> _loadFields() async {
    final fields = await DatabaseHelper.instance.getFields();
    setState(() {
      _existingFields = fields.map((field) => field['fieldName'].toString()).toList();
    });
  }

  @override
  void dispose() {
    _productUsedController.dispose();
    _quantityController.dispose();
    _customTreatmentTypeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _updateStatusBasedOnDate(); // Automatically set status based on date
      });
    }
  }

  void _updateStatusBasedOnDate() {
    if (_selectedDate != null) {
      final now = DateTime.now();
      if (_selectedDate!.isBefore(now)) {
        _selectedStatus = 'Done';
      } else {
        _selectedStatus = 'Planned';
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Invalid Date';
    }
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('New Treatment', style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate)
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
                  setState(() {
                    _selectedStatus = value;
                  });
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
                  setState(() {
                    _selectedTreatmentType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a treatment type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_selectedTreatmentType == 'Other') ...[
                TextFormField(
                  controller: _customTreatmentTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Treatment Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a treatment type';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedField,
                      items: _existingFields.map((field) {
                        return DropdownMenuItem(
                          value: field,
                          child: Text(field),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Field',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedField = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a field';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewFieldPage(onAdd: (newField) {
                          setState(() {
                            _existingFields.add(newField['fieldName']);
                          });
                        })),
                      );
                      if (result == true) {
                        await _loadFields();
                      }
                    },
                    icon: const Icon(Icons.add),
                    tooltip: 'Add New Field',
                  ),
                ],
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
                  labelText: 'Quantity',
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
    if (_formKey.currentState!.validate()){
      try {
        // Check for null values and validate them
        if (_selectedDate == null) {
          throw Exception('Date is required'); // Custom error message
        }
        
        // Build the new treatment map
        Map<String, dynamic> newTreatment = {
          'date': DateFormat("yyyy-MM-dd").format(_selectedDate!), // Ensure non-null date
          'status': _selectedStatus, // Ensure it's not null
          'treatment_type': _selectedTreatmentType, // Ensure it's not null
          'field': _selectedField, // Ensure it's not null
          'product_used': _productUsedController.text, // Ensure it's not empty
          'quantity': double.tryParse(_quantityController.text) ?? 0.0, // Avoid null
        };
         DatabaseHelper.instance.insertTreatments(newTreatment);
        // Navigate back to the previous screen
        Navigator.pop(context, true);

      } catch (e) {
        debugPrint('Error adding treatment: $e'); // Improved error handling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding treatment: $e')), // Display error message
        );
      }
    }
  },
                child: const Text('Add Treatment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
