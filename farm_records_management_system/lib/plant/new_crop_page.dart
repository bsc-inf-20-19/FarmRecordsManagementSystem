import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:flutter/material.dart';

class NewCropPage extends StatefulWidget {
  const NewCropPage({Key? key}) : super(key: key);

  @override
  _NewCropPageState createState() => _NewCropPageState();
}

class _NewCropPageState extends State<NewCropPage> {
  final _cropNameController = TextEditingController();
  final _harvestUnitsController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _cropNameController.dispose();
    _harvestUnitsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _addNewCrop() async {
    if (_cropNameController.text.isNotEmpty && _harvestUnitsController.text.isNotEmpty) {
      Map<String, dynamic> cropData = {
        'name': _cropNameController.text,
        'harvestUnits': _harvestUnitsController.text,
        'notes': _notesController.text,
      };

      await DatabaseHelper.instance.insertCrop(cropData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New crop added successfully')),
      );

      Navigator.pop(context, true); // Return true to indicate a new crop was added
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Crop'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30.0),
            _buildHeader("Crop Name"),
            const SizedBox(height: 10.0),
            _buildTextField(_cropNameController, "Crop Name", Icons.eco),
            const SizedBox(height: 30.0),
            _buildHeader("Harvest Units"),
            const SizedBox(height: 10.0),
            _buildTextField(_harvestUnitsController, "Harvest Units", Icons.agriculture),
            const SizedBox(height: 30.0),
            _buildHeader("Notes"),
            const SizedBox(height: 10.0),
            _buildTextField(_notesController, "Notes", Icons.notes),
            const SizedBox(height: 40.0),
            Center(child: _buildAddCropButton(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green.shade700),
        ),
      ),
    );
  }

  Widget _buildAddCropButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _addNewCrop,
      icon: const Icon(Icons.add, size: 24.0, color: Colors.white),
      label: const Text("Add Crop", style: TextStyle(fontSize: 18.0, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.green.shade700,
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
