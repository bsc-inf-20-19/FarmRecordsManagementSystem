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
  late TextEditingController _dateController;

  String? _selectedCrop;
  String? _selectedField;

  List<String> _crops = [];
  List<String> _fields = [];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.planting['description']);
    _cropCompanyController = TextEditingController(text: widget.planting['cropCompany']);
    _cropTypeController = TextEditingController(text: widget.planting['cropType']);
    _cropPlotNumberController = TextEditingController(text: widget.planting['cropPlotNumber']);
    _cropHarvestController = TextEditingController(text: widget.planting['cropHarvest']);
    _dateController = TextEditingController(text: widget.planting['date']);

    _selectedCrop = widget.planting['crop'];
    _selectedField = widget.planting['field'];

    _fetchDropdownData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _cropCompanyController.dispose();
    _cropTypeController.dispose();
    _cropPlotNumberController.dispose();
    _cropHarvestController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _fetchDropdownData() async {
    _crops = await DatabaseHelper.instance.getCropSuggestions();
    _fields = await DatabaseHelper.instance.getFieldsNames();

    setState(() {
      // Set default values for dropdowns
      _selectedCrop = widget.planting['crop'];
      _selectedField = widget.planting['field'];
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
      'date': _dateController.text,
    };

    await DatabaseHelper.instance.updatePlanting(updatedPlanting);
    Navigator.pop(context);
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
            DropdownButtonFormField<String>(
              value: _selectedCrop,
              items: _crops.map((crop) {
                return DropdownMenuItem<String>(
                  value: crop,
                  child: Text(crop),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCrop = value;
                });
              },
              decoration: InputDecoration(labelText: 'Crop'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedField,
              items: _fields.map((field) {
                return DropdownMenuItem<String>(
                  value: field,
                  child: Text(field),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedField = value;
                });
              },
              decoration: InputDecoration(labelText: 'Field'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Seed Quantity'),
            ),
            TextField(
              controller: _cropCompanyController,
              decoration: const InputDecoration(labelText: 'Seed Company'),
            ),
            TextField(
              controller: _cropTypeController,
              decoration: const InputDecoration(labelText: 'Seed Type'),
            ),
            TextField(
              controller: _cropPlotNumberController,
              decoration: const InputDecoration(labelText: 'Seed Plot Number'),
            ),
            TextField(
              controller: _cropHarvestController,
              decoration: const InputDecoration(labelText: 'Estimated Harvest'),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white, // Ensure text is white
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
