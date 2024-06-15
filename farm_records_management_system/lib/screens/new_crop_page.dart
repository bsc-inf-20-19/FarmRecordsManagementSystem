import 'package:flutter/material.dart';
import 'package:farm_records_management_system/screens/databaseHelper.dart';

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
            _buildTextField(_harvestUnitsController, "Harvest Units", Icons.filter_vintage),
            const SizedBox(height: 30.0),
            _buildHeader("Notes"),
            const SizedBox(height: 10.0),
            _buildTextField(_notesController, "Notes", Icons.note, maxLines: 5),
            const SizedBox(height: 50.0),
            Center(
              child: _buildAddButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: _addNewCrop,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: const Text(
        'Add Crop',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }
}
