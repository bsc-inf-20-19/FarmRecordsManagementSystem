import 'package:farm_records_management_system/home/components/details/harvestDetailView.dart';
import 'package:flutter/material.dart';

class AddHarvestPage extends StatefulWidget {
  const AddHarvestPage({Key? key}) : super(key: key);
  
  @override
  _AddHarvestState createState() => _AddHarvestState();
}

class _AddHarvestState extends State<AddHarvestPage> {

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

  _AddHarvestState(){
    _cropDropdownController.text = _harvestQualityList[0];
    _fieldDropdownController.text = _fieldList[0];
  }

  final _dateController = TextEditingController(); 
  final _batchController = TextEditingController();
   final _harvestQuantityController = TextEditingController();
    final _harvestQualityController = TextEditingController();
     final _unitCostController = TextEditingController();
      final _harvestIncomeController = TextEditingController();
            final __harvestNotesController = TextEditingController();

 
  List<String> _harvestQualityList = ["Maize", "Tobacco", "G. Nuts", "Beans"];
  

   final _cropDropdownController= TextEditingController();

  List<String> _fieldList = ["M01 Field", "T01 Field", "G01 Field", "B01 Field"];

  final _fieldDropdownController= TextEditingController();

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
   __harvestNotesController.dispose();
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
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            
            TextField(
              decoration: InputDecoration(
                labelText: 'Harvest date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
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

            //Textfields for seeds infomation
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
              myController: __harvestNotesController,
              fieldName: "Notes",
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
    style: OutlinedButton.styleFrom(minimumSize: Size(200, 50)),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return HarvestDetailView(
            cropList: _cropDropdownController.text,
            batchNo: _batchController.text,
            harvestQuantity: _harvestQuantityController.text,
            harvestQuality: _harvestQualityController.text,
            unitCost: _unitCostController.text,
            harvestIncome: _harvestIncomeController.text,
            harvestNotes: __harvestNotesController.text,
          );
        }),
      );        
      },
    child: Text("Add"),
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
