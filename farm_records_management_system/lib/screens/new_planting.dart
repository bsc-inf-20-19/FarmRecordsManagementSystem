import 'package:farm_records_management_system/screens/databaseHelper.dart';
import 'package:farm_records_management_system/screens/detail_page.dart';
import 'package:flutter/material.dart';

class NewPlantPage extends StatefulWidget {
  const NewPlantPage({super.key});

  @override
  _NewPlantPageState createState() => _NewPlantPageState();
}

class _NewPlantPageState extends State<NewPlantPage> {
  DateTime? _selectedDate;

  // Function to show the date picker and set the selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    // If the user picked a date, set the selected date state
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  _NewPlantPageState() {
    _cropDropdownController.text = _cropTypeList[0];
    _fieldDropdownController.text = _fieldList[0];
  }

  final _dateController = TextEditingController();
  final _cropController = TextEditingController();
  final _cropDecController = TextEditingController();
  final _cropCompanyController = TextEditingController();
  final _cropTypeController = TextEditingController();
  final _cropLotController = TextEditingController();
  final _cropHarvestController = TextEditingController();

  final List<String> _cropTypeList = ["Maize", "Tobacco", "G. Nuts", "Beans"];

  final _cropDropdownController = TextEditingController();

  final List<String> _fieldList = [
    "M01 Field",
    "T01 Field",
    "G01 Field",
    "B01 Field"
  ];

  final _fieldDropdownController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _cropController.dispose();
    _cropDecController.dispose();
    _cropCompanyController.dispose();
    _cropTypeController.dispose();
    _cropLotController.dispose();
    _cropHarvestController.dispose();
    _cropDropdownController.dispose();
    _fieldDropdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Planting'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Select a date',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
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
            // DropDown crop name and field
            DropdownButtonFormField(
              value: _cropDropdownController.text,
              items: _cropTypeList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _cropDropdownController.text = val as String;
                });
              },
              icon: const Icon(Icons.arrow_drop_down_outlined),
              decoration: const InputDecoration(
                  labelText: "Select crop", border: UnderlineInputBorder()),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField(
              value: _fieldDropdownController.text,
              items: _fieldList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _fieldDropdownController.text = val as String;
                });
              },
              icon: const Icon(Icons.arrow_drop_down_outlined),
              decoration: const InputDecoration(
                  labelText: "Select field", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10.0),

            // Textfields for seeds information
            MyTextField(
              myController: _cropDecController,
              fieldName: "Seed quantity",
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropCompanyController,
              fieldName: "Seed company",
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropTypeController,
              fieldName: "Seed type",
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropLotController,
              fieldName: "Seed lot number",
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropHarvestController,
              fieldName: "Estimated harvest",
            ),
            const SizedBox(height: 10.0),
            myBtn(context)
          ],
        ),
      ),
    );
  }

  OutlinedButton myBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
      onPressed: () async {
        // Create a map to hold the data
        Map<String, dynamic> plantingData = {
          'date': _selectedDate != null ? '${_selectedDate!.toLocal()}'.split(' ')[0] : '',
          // 'cropList': _cropDropdownController.text,
          // 'fieldList': _fieldDropdownController.text,
          // 'cropDescription': _cropDecController.text,
          'cropCompany': _cropCompanyController.text,
          'cropType': _cropTypeController.text,
          'cropLotNumber': _cropLotController.text,
          'cropHarvest': _cropHarvestController.text,
        };

        // Insert data into the database
        await DatabaseHelper.insertPlanting(plantingData);

        // Navigate to the Details page and pass the data
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Details(
              // cropList: _cropDropdownController.text,
              // fieldList: _fieldDropdownController.text,
              // cropDescription: _cropDecController.text,
              cropCompany: _cropCompanyController.text,
              cropType: _cropTypeController.text,
              cropLotNumber: _cropLotController.text,
              cropHarvest: _cropHarvestController.text,
            );
          }),
        );
      },
      child: const Text("Add"),
    );
  }
}

class MyTextField extends StatelessWidget {
  MyTextField({
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
