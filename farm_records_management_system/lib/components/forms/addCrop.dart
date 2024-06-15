import 'package:farm_records_management_system/components/details/cropDetailView.dart';
import 'package:flutter/material.dart';

class AddCropPage extends StatefulWidget {
  const AddCropPage({Key? key}) : super(key: key);
  
  @override
  _AddCropState createState() => _AddCropState();
}

class _AddCropState extends State<AddCropPage> {

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

  _AddCropState(){
    _cropDropdownController.text = _cropTypeList[0];
    _fieldDropdownController.text = _fieldList[0];
  }

  final _dateController = TextEditingController(); 
  final _cropController = TextEditingController();
  final _seedQuantityController = TextEditingController();
   final _cropCompanyController = TextEditingController();
    final _cropTypeController = TextEditingController();
     final _cropLotController = TextEditingController();
      final _cropHarvestController = TextEditingController();
            final __farmNotesController = TextEditingController();

 
  List<String> _cropTypeList = ["Maize", "Tobacco", "G. Nuts", "Beans"];
  

   final _cropDropdownController= TextEditingController();

  List<String> _fieldList = ["M01 Field", "T01 Field", "G01 Field", "B01 Field"];

  final _fieldDropdownController= TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
   _cropController.dispose();
   _seedQuantityController.dispose();
   _cropCompanyController.dispose();
   _cropTypeController.dispose();
   _cropLotController.dispose();
   _cropHarvestController.dispose();
   _cropDropdownController.dispose();
   _fieldDropdownController.dispose();
   __farmNotesController.dispose();
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
              items: _cropTypeList.map(
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
              labelText: "Select crop",
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
              myController: _seedQuantityController,
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
              fieldName: "Estimated hrarvest",
            ),
            SizedBox(height: 10.0),
             MyTextField(
              myController: __farmNotesController,
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
          return CropDetailView(
            cropList: _cropDropdownController.text,
            fieldList: _fieldDropdownController.text,
            seedQuantity: _seedQuantityController.text,
            cropCompany: _cropCompanyController.text,
            cropType: _cropTypeController.text,
            cropLotNumber: _cropLotController.text,
            cropHarvest: _cropHarvestController.text,
          );
        }),
      );        
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
