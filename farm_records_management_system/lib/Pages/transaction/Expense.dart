import 'package:farm_records_management_system/Models/Expenses_model.dart';
import 'package:farm_records_management_system/Services/database_helper.dart';
import 'package:flutter/material.dart';

class Expense extends StatefulWidget {
  const Expense({Key? key}) : super(key: key);

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
                        child: Text(e),
                        value: e,
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
              decoration: InputDecoration(
                  labelText: "Select crop", border: UnderlineInputBorder()),
            ),
            SizedBox(height: 10.0),
            DropdownButtonFormField(
              value: _selectFieldVal,
              items: _fieldList
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
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
              decoration: InputDecoration(
                  labelText: "Select field", border: UnderlineInputBorder()),
            ),
            SizedBox(height: 10.0),

            //Textfields for expense details
            MyTextField(
              myController: _nameController,
              fieldName: "Expense Name", id: 'expense',
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _amountController,
              fieldName: "Amount",
              keyboardType: TextInputType.number, id: 'amount',
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _descriptionController,
              fieldName: "Description",
              maxLines: 3, id: 'descript',
            ),
            SizedBox(height: 10.0),
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
        // Create an instance of Expenses model with the input data
        Expenses expense = Expenses(
          amount: double.parse(_amountController.text),
          expenseName: _nameController.text,
          date: _selectedDate != null
              ? _selectedDate.toString()
              : '', // Format date as needed
          description: _descriptionController.text,
          id: 0, // You can set id to 0 as it's auto-incremented in the database
        );

        // Add the expense to the database
        int result = await DatabaseHelper.addExpense(expense);

        if (result != 0) {
          // If the insertion was successful, navigate back to the transaction screen
          Navigator.pop(context);
        } else {
          // Handle error if insertion failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add expense')),
          );
        }
      },
      child: Text("Add"),
    );
  }
}

class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
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
