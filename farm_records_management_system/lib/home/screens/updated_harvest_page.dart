import 'package:farm_records_management_system/home/components/details/harvestDetailView.dart';
import 'package:farm_records_management_system/home/screens/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateHarvestPage extends StatefulWidget {
  final Map<String, dynamic> harvestData;

  const UpdateHarvestPage({Key? key, required this.harvestData}) : super(key: key);

  @override
  _UpdateHarvestState createState() => _UpdateHarvestState();
}

class _UpdateHarvestState extends State<UpdateHarvestPage> {
  DateTime? _selectedDate;
  final _dateController = TextEditingController(); 
  final _batchController = TextEditingController();
  final _harvestQuantityController = TextEditingController();
  final _harvestQualityController = TextEditingController();
  final _unitCostController = TextEditingController();
  final _harvestIncomeController = TextEditingController();
  final _harvestNotesController = TextEditingController();
  final _cropDropdownController = TextEditingController();
  final _fieldDropdownController = TextEditingController();

  List<String> _harvestQualityList = ["Maize", "Tobacco", "G. Nuts", "Beans"];
  List<String> _fieldList = ["M01 Field", "T01 Field", "G01 Field", "B01 Field"];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _selectedDate = DateTime.parse(widget.harvestData['date']);
    _dateController.text = _selectedDate != null
        ? '${_selectedDate!.toLocal()}'.split(' ')[0]
        : '';
    _cropDropdownController.text = widget.harvestData['cropList'];
    _batchController.text = widget.harvestData['batchNo'];
    _harvestQuantityController.text = widget.harvestData['harvestQuantity'];
    _harvestQualityController.text = widget.harvestData['harvestQuality'];
    _unitCostController.text = widget.harvestData['unitCost'];
    _harvestIncomeController.text = widget.harvestData['harvestIncome'];
    _harvestNotesController.text = widget.harvestData['harvestNotes'];
  }

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
        _dateController.text = '${_selectedDate!.toLocal()}'.split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _batchController.dispose();
    _harvestQuantityController.dispose();
    _harvestQualityController.dispose();
    _unitCostController.dispose();
    _harvestIncomeController.dispose();
    _cropDropdownController.dispose();
    _fieldDropdownController.dispose();
    _harvestNotesController.dispose();
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Harvest'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            //Harvest date
            TextField(
              decoration: InputDecoration(
                labelText: 'Harvest date',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
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
            //DropDown crop name  and field
            DropdownButtonFormField(
              value: _cropDropdownController.text,
              items: _harvestQualityList.map(
                (e) => DropdownMenuItem(child: Text(e), value: e,)
              ).toList(), 
              onChanged: (val) {
                setState(() {
                  _cropDropdownController.text = val as String;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down_outlined,
              ),
              decoration: InputDecoration(
                labelText: "Select crop to harvest",
                border: UnderlineInputBorder()
              ),
            ),
            SizedBox(height: 10.0),
            DropdownButtonFormField(
              value: _fieldDropdownController.text,
              items: _fieldList.map(
                (e) => DropdownMenuItem(child: Text(e), value: e,)
              ).toList(), 
              onChanged: (val) {
                setState(() {
                  _fieldDropdownController.text = val as String;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down_outlined,
              ),
              decoration: InputDecoration(
                labelText: "Select field",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 10.0),
            //Textfields for harvest information
            MyTextField(
              myController: _batchController,
              fieldName: "Batch No",
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _harvestQuantityController,
              fieldName: "Harvest quantity",
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _harvestQualityController,
              fieldName: "Harvest quality",
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _unitCostController,
              fieldName: "Unit cost",
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _harvestIncomeController,
              fieldName: "Estimated harvest income",
            ),
            SizedBox(height: 10.0),
            MyTextField(
              myController: _harvestNotesController,
              fieldName: "Notes",
            ),
            SizedBox(height: 10.0),
            myUpdateBtn(context)
          ],
        ),
      ),
    );
  }

  OutlinedButton myUpdateBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: Size(200, 50)),
      onPressed: () async {
        Map<String, dynamic> updatedHarvest = {
          'date': _selectedDate != null ? '${_selectedDate!.toLocal()}'.split(' ')[0] : '',
          'cropList': _cropDropdownController.text,
          'batchNo': _batchController.text,
          'harvestQuantity': _harvestQuantityController.text,
          'harvestQuality': _harvestQualityController.text,
          'unitCost': _unitCostController.text,
          'harvestIncome': _harvestIncomeController.text,
          'harvestNotes': _harvestNotesController.text,
        };

        // Update data in the database
        await DatabaseHelper.updateHarvest(widget.harvestData['id'], updatedHarvest);

        // Navigate to HarvestDetailView
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return HarvestDetailView(
              cropList: _cropDropdownController.text,
              batchNo: _batchController.text,
              harvestQuantity: _harvestQuantityController.text,
              harvestQuality: _harvestQualityController.text,
              unitCost: _unitCostController.text,
              harvestIncome: _harvestIncomeController.text,
              harvestNotes: _harvestNotesController.text,
            );
          }),
        );
      },
      child: Text("Update"),
    );
  }
}

// ignore: must_be_immutable
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
