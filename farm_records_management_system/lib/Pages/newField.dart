import 'package:flutter/material.dart';
import 'package:farm_records_management_system/widgets/customInputField.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';

class NewFieldPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const NewFieldPage({Key? key, required this.onAdd}) : super(key: key);

  @override
  _NewFieldPageState createState() => _NewFieldPageState();
}

class _NewFieldPageState extends State<NewFieldPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _fieldSizeController = TextEditingController();

  String? _selectedFieldType;
  String? _selectedLightProfile;
  String? _selectedFieldStatus;

  bool _isSaving = false;

  @override
  void dispose() {
    _fieldNameController.dispose();
    _notesController.dispose();
    _fieldSizeController.dispose();
    super.dispose();
  }

  Future<void> _addField() async {
    if (_isSaving) return;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      Map<String, dynamic> newField = {
        'fieldName': _fieldNameController.text,
        'fieldType': _selectedFieldType,
        'lightProfile': _selectedLightProfile,
        'fieldStatus': _selectedFieldStatus,
        'fieldSize': _fieldSizeController.text,
        'notes': _notesController.text,
      };

      await DatabaseHelper.instance.insertField(newField);
      widget.onAdd(newField);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Field'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomInputField(
                label: 'Field Name',
                controller: _fieldNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a field name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedFieldType,
                decoration: const InputDecoration(labelText: 'Select Field Type'),
                items: ['Field/outdoor', 'Greenhouse', 'Speeding', 'Grow tent']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFieldType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a field type';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedLightProfile,
                decoration: const InputDecoration(labelText: 'Select Light Profile'),
                items: [
                  'Full sun',
                  'Full To Partial Sun',
                  'Partial Sun',
                  'Partial Shade',
                  'Full Shade'
                ].map((profile) => DropdownMenuItem(
                      value: profile,
                      child: Text(profile),
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLightProfile = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a light profile';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedFieldStatus,
                decoration: const InputDecoration(labelText: 'Select Field Status'),
                items: [
                  'Available',
                  'Partially Cultivated',
                  'Fully cultivated'
                ].map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFieldStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a field status';
                  }
                  return null;
                },
              ),
              CustomInputField(
                label: 'Field Size (Optional)',
                controller: _fieldSizeController,
                keyboardType: TextInputType.number,
              ),
              CustomInputField(
                label: 'Write Notes',
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addField,
                child: _isSaving ? const CircularProgressIndicator() : const Text('Add Field'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
