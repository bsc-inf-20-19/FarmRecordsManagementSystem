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

      try {
        await DatabaseHelper.instance.insertField(newField);
        widget.onAdd(newField);
        Navigator.pop(context, true);
      } catch (error) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving field: $error'),
          ),
        );
      }
    }
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 14.0),
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.green.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.green.shade700),
        ),
      ),
      style: const TextStyle(fontSize: 14.0),
    );
  }

  Widget _buildDropdownField(String? value, String labelText, IconData icon, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 14.0),
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.green.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.green.shade700),
        ),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14.0)))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select a value' : null,
    );
  }

  Widget _buildAddFieldButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isSaving ? null : _addField,
      icon: const Icon(Icons.add, size: 20.0, color: Colors.white),
      label: _isSaving ? const CircularProgressIndicator() : const Text("Add Field", style: TextStyle(fontSize: 16.0, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.green.shade700,
        minimumSize: const Size(180, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Field'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              _buildHeader("Field Name"),
              const SizedBox(height: 5.0),
              _buildTextField(_fieldNameController, "Field Name", Icons.location_on),
              const SizedBox(height: 20.0),
              _buildHeader("Field Type"),
              const SizedBox(height: 5.0),
              _buildDropdownField(_selectedFieldType, "Select Field Type", Icons.category, ['Field/outdoor', 'Greenhouse', 'Speeding', 'Grow tent'], (value) {
                setState(() {
                  _selectedFieldType = value;
                });
              }),
              const SizedBox(height: 20.0),
              _buildHeader("Light Profile"),
              const SizedBox(height: 5.0),
              _buildDropdownField(_selectedLightProfile, "Select Light Profile", Icons.wb_sunny, ['Full sun', 'Full To Partial Sun', 'Partial Sun', 'Partial Shade', 'Full Shade'], (value) {
                setState(() {
                  _selectedLightProfile = value;
                });
              }),
              const SizedBox(height: 20.0),
              _buildHeader("Field Status"),
              const SizedBox(height: 5.0),
              _buildDropdownField(_selectedFieldStatus, "Select Field Status", Icons.info, ['Available', 'Partially Cultivated', 'Fully cultivated'], (value) {
                setState(() {
                  _selectedFieldStatus = value;
                });
              }),
              const SizedBox(height: 20.0),
              _buildHeader("Field Size (Optional)"),
              const SizedBox(height: 5.0),
              _buildTextField(_fieldSizeController, "Field Size", Icons.square_foot, inputType: TextInputType.number),
              const SizedBox(height: 20.0),
              _buildHeader("Notes"),
              const SizedBox(height: 5.0),
              _buildTextField(_notesController, "Write Notes", Icons.notes, inputType: TextInputType.multiline),
              const SizedBox(height: 30.0),
              Center(child: _buildAddFieldButton(context)),
            ],
          ),
        ),
      ),
    );
  }
}
