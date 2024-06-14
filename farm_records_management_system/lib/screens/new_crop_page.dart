import 'package:farm_records_management_system/screens/databaseHelper.dart';
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

      await DatabaseHelper.insertCrop(cropData);

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
        title: const Text('New Crop'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            MyTextField(
              myController: _cropNameController,
              fieldName: "Crop Name",
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _harvestUnitsController,
              fieldName: "Harvest Units",
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _notesController,
              fieldName: "Notes",
            ),
            const SizedBox(height: 20.0),
            myBtn(context),
          ],
        ),
      ),
    );
  }

  OutlinedButton myBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
      onPressed: _addNewCrop,
      child: const Text("Add Crop"),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.myController,
    required this.fieldName,
    this.myIcon = Icons.verified_user_outlined,
    this.prefixIconColor = Colors.blueAccent,
  }) : super(key: key);

  final TextEditingController myController;
  final String fieldName;
  final IconData myIcon;
  final Color prefixIconColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      decoration: InputDecoration(
        labelText: fieldName,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade300),
        ),
      ),
    );
  }
}
