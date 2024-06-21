import 'package:flutter/material.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';

class EditPlantingPage extends StatefulWidget {
  final Map<String, dynamic> planting;

  const EditPlantingPage({Key? key, required this.planting}) : super(key: key);

  @override
  _EditPlantingPageState createState() => _EditPlantingPageState();
}

class _EditPlantingPageState extends State<EditPlantingPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _cropCompanyController;
  late TextEditingController _cropTypeController;
  late TextEditingController _cropPlotNumberController;
  late TextEditingController _cropHarvestController;
  DateTime? _selectedDate;

  String? _selectedCrop;
  String? _selectedField;

  List<String> _cropTypeList = [];
  List<String> _fieldList = [];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.planting['description']);
    _cropCompanyController = TextEditingController(text: widget.planting['cropCompany']);
    _cropTypeController = TextEditingController(text: widget.planting['cropType']);
    _cropPlotNumberController = TextEditingController(text: widget.planting['cropPlotNumber']);
    _cropHarvestController = TextEditingController(text: widget.planting['cropHarvest']);
    _selectedDate = DateTime.tryParse(widget.planting['date']);

    _selectedCrop = widget.planting['crop'];
    _selectedField = widget.planting['field'];

    _fetchCropTypes();
    _fetchFields();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _cropCompanyController.dispose();
    _cropTypeController.dispose();
    _cropPlotNumberController.dispose();
    _cropHarvestController.dispose();
    super.dispose();
  }

  Future<void> _fetchCropTypes() async {
    final crops = await DatabaseHelper.instance.getCropSuggestions();
    setState(() {
      _cropTypeList = crops;
    });
  }

  Future<void> _fetchFields() async {
    final fields = await DatabaseHelper.instance.getFieldsNames();
    setState(() {
      _fieldList = fields;
    });
  }

  Future<void> _saveChanges() async {
    final updatedPlanting = {
      'id': widget.planting['id'],
      'crop': _selectedCrop,
      'field': _selectedField,
      'description': _descriptionController.text,
      'cropCompany': _cropCompanyController.text,
      'cropType': _cropTypeController.text,
      'cropPlotNumber': _cropPlotNumberController.text,
      'cropHarvest': _cropHarvestController.text,
      'date': _selectedDate != null ? _selectedDate!.toIso8601String() : '',
    };

    await DatabaseHelper.instance.updatePlanting(updatedPlanting);
    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Planting'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Select a date',
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.green),
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
              ),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField(
              value: _selectedCrop,
              items: _cropTypeList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCrop = val as String?;
                });
              },
              icon: const Icon(Icons.arrow_drop_down_outlined, color: Colors.green),
              decoration: const InputDecoration(
                labelText: "Select crop",
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField(
              value: _selectedField,
              items: _fieldList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedField = val as String?;
                });
              },
              icon: const Icon(Icons.arrow_drop_down_outlined, color: Colors.green),
              decoration: const InputDecoration(
                labelText: "Select field",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Seed Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _cropCompanyController,
              decoration: const InputDecoration(
                labelText: 'Seed Company',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _cropTypeController,
              decoration: const InputDecoration(
                labelText: 'Seed Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _cropPlotNumberController,
              decoration: const InputDecoration(
                labelText: 'Seed Plot Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _cropHarvestController,
              decoration: const InputDecoration(
                labelText: 'Estimated Harvest',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(color: Colors.green, width: 2),
              ),
              onPressed: _saveChanges,
              icon: const Icon(Icons.save, color: Colors.green),
              label: const Text("Save Changes", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
