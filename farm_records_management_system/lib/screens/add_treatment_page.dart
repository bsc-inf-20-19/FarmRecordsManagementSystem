import 'package:farm_records_management_system/screens/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTreatmentPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd; // Callback for adding treatments
  final List<String> existingFields; // List of existing fields for dropdown
  final VoidCallback onNewFieldRequested; // Callback to add new fields

  const AddTreatmentPage({
    super.key,
    required this.onAdd,
    required this.existingFields,
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

  @override
  void dispose() {
    _productUsedController.dispose();
    _quantityController.dispose();
    _customTreatmentTypeController.dispose();
    super.dispose(); // Proper resource cleanup
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
      });
    }
  }

  String _getStatusFromDate(DateTime date) {
    return date.isAfter(DateTime.now()) ? 'Planned' : 'Done';
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
        title: const Text('Add New Treatment'),
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
                        ? _formatDate(_selectedDate) // Format the date
                        : 'Select Date', // Prompt to select a date
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Dropdown for Status
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
              // Dropdown for Treatment Type
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
              // Dropdown for Field
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedField,
                      items: widget.existingFields.map((field) {
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
                    onPressed: widget.onNewFieldRequested,
                    icon: const Icon(Icons.add),
                    tooltip: 'Add New Field',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Product Used TextField
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
              // Quantity TextField
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
              // Add Treatment Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
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
                      DatabaseHelper.insertTreatment(newTreatment);
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
