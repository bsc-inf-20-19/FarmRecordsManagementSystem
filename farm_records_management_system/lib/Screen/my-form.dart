import 'package:farm_records_management_system/Screen/Details.dart';
import 'package:flutter/material.dart';
import 'package:farm_records_management_system/Pages/databaseHelper.dart'; // Import the DatabaseHelper class

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<MyForm> {
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

  final _livestockController = TextEditingController();
  final _livestockDescdriptionController = TextEditingController();
  final _livestockBreedController = TextEditingController();

  final _livestockTypeList = ["Cattle", "Poultry", "Goats", "Pigs"];
  String? _selectVal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Livestock Record'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Select a BirthDate',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              controller: TextEditingController(
                text: _selectedDate != null
                    ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                    : '',
              ),
              readOnly: true,
            ),
            SizedBox(height: 10.0),
            DropdownButtonFormField(
              value: _selectVal,
              items: _livestockTypeList
                  .map((e) => DropdownMenuItem(child: Text(e), value: e))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectVal = val as String?;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down_circle_outlined,
              ),
              decoration: InputDecoration(
                labelText: "Select Livestock Type",
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _livestockDescdriptionController,
              fieldName: "LiveStock quantity(Number of offsprings)",
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _livestockBreedController,
              fieldName: "Livestock Breed",
            ),
            SizedBox(height: 10.0),
            myBtn(context),
          ],
        ),
      ),
    );
  }

  OutlinedButton myBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
      onPressed: () async {
        // Create a map of livestock data
        final livestockData = {
          'livestock_name': _livestockController.text,
          'livestock_description': _livestockDescdriptionController.text,
          'livestock_breed': _livestockBreedController.text,
          'livestock_type': _selectVal ?? "", // Provide a default value if _selectVal is null
        };

        // Insert the livestock record into the database
        await DatabaseHelper.insertLivestock(livestockData);

        // Navigate to the Details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Details(
              livestockName: _livestockController.text,
              livestockDescription: _livestockDescdriptionController.text,
              livestockBreed: _livestockBreedController.text,
              livestockType: _selectVal ?? "", // Provide a default value if _selectVal is null
            ),
          ),
        );
      },
      child: Text("Save"),
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
  });

  final TextEditingController myController;
  String fieldName;
  final IconData myIcon;
  Color prefixIconColor;

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
