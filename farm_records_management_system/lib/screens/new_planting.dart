import 'package:flutter/material.dart';
import 'package:farm_records_management_system/screens/detail_page.dart';

class NewPlantPage extends StatefulWidget {
  const NewPlantPage({Key? key}) : super(key: key);

  @override
  _NewPlantPageState createState() => _NewPlantPageState();
}

class _NewPlantPageState extends State<NewPlantPage> {
  DateTime? _selectedDate;

  final _dateController = TextEditingController();
  final _cropDecController = TextEditingController();
  final _cropCompanyController = TextEditingController();
  final _cropTypeController = TextEditingController();
  final _cropLotController = TextEditingController();
  final _cropHarvestController = TextEditingController();

  final List<String> _cropTypeList = ["Maize", "Tobacco", "G. Nuts", "Beans"];
  final _cropDropdownController = TextEditingController();

  final List<String> _fieldList = ["M01 Field", "T01 Field", "G01 Field", "B01 Field"];
  final _fieldDropdownController = TextEditingController();

  _NewPlantPageState() {
    _cropDropdownController.text = _cropTypeList[0];
    _fieldDropdownController.text = _fieldList[0];
  }

  @override
  void dispose() {
    _dateController.dispose();
    _cropDecController.dispose();
    _cropCompanyController.dispose();
    _cropTypeController.dispose();
    _cropLotController.dispose();
    _cropHarvestController.dispose();
    _cropDropdownController.dispose();
    _fieldDropdownController.dispose();
    super.dispose();
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
        _dateController.text = _selectedDate!.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Planting'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Select a date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
              ),
              controller: _dateController,
              readOnly: true,
            ),
            SizedBox(height: 10.0),
            _buildDropdownField("Select crop", _cropTypeList, _cropDropdownController),
            SizedBox(height: 10.0),
            _buildDropdownField("Select field", _fieldList, _fieldDropdownController),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _cropDecController,
              fieldName: "Seed quantity",
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _cropCompanyController,
              fieldName: "Seed company",
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _cropTypeController,
              fieldName: "Seed type",
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _cropLotController,
              fieldName: "Seed lot number",
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _cropHarvestController,
              fieldName: "Estimated harvest",
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      cropList: _cropDropdownController.text,
                      fieldList: _fieldDropdownController.text,
                      cropDescription: _cropDecController.text,
                      cropCompany: _cropCompanyController.text,
                      cropType: _cropTypeController.text,
                      cropLotNumber: _cropLotController.text,
                      cropHarvest: _cropHarvestController.text,
                    ),
                  ),
                );
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String labelText, List<String> items, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: DropdownButton<String>(
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              controller.text = newValue!;
            });
          },
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
      ),
      readOnly: true,
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.myController,
    required this.fieldName,
  }) : super(key: key);

  final TextEditingController myController;
  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: fieldName,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
      ),
      controller: myController,
    );
  }
}
