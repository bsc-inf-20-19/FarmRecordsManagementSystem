import 'package:farm_records_management_system/Pages/databaseHelper.dart';
import 'package:farm_records_management_system/Pages/transaction/transactions.dart';
  import 'package:flutter/material.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Expense> {
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

  _HomeState() {
    _selectVal = _cropTypeList[0];
    _selectFieldVal = _fieldList[0];
  }

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();


  final _cropTypeList = ["Maize", "Tobacco", "G. Nuts", "Beans"];
  String? _selectVal = "";

  final _fieldList = ["M01 Field", "T01 Field", "G01 Field", "B01 Field"];
  String? _selectFieldVal = "";

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense'),
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
              ),
              controller: TextEditingController(
                text: _selectedDate != null
                    ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                    : '',
              ),
              readOnly: true,
            ),

            //DropDown crop name  and field
            DropdownButtonFormField(
              value: _selectVal,
              items: _cropTypeList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectVal = val as String;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down_circle_outlined,
              ),
              decoration: const InputDecoration(
                  labelText: "Select crop", border: UnderlineInputBorder()),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField(
              value: _selectFieldVal,
              items: _fieldList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectFieldVal = val as String;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down_circle_outlined,
              ),
              decoration: const InputDecoration(
                  labelText: "Select field", border: UnderlineInputBorder()),
            ),
            const SizedBox(height: 10.0),

            //Textfields for expense details
            MyTextField(
              myController: _nameController,
              fieldName: "Expense Name",
              id: 'expense',
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _amountController,
              fieldName: "Amount",
              keyboardType: TextInputType.number,
              id: 'amount',
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _descriptionController,
              fieldName: "Description",
              maxLines: 3,
              id: 'descript',
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
        // _saveData();
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) { 
        return Trans(
          expenseName: _nameController.text,
          amount: double.parse(_amountController.text),
          description: _descriptionController.text,
        );
          }),
        );
      },
      child: const Text("Add"),
    );
  }
}

class MyTextField extends StatelessWidget {
  MyTextField({super.key, 
    required this.myController,
    required this.fieldName,
    this.keyboardType,
    this.onTap,
    this.maxLines = 1,
    required this.id,
  });

  final TextEditingController myController;
  String fieldName;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final int maxLines;
  final String id;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onTap: onTap,
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
