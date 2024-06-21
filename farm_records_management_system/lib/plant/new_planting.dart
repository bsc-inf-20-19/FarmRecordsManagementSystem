import 'package:farm_records_management_system/Pages/newField.dart';
import 'package:flutter/material.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/plant/detail_page.dart';
import 'new_crop_page.dart';

class NewPlantPage extends StatefulWidget {
  const NewPlantPage({Key? key}) : super(key: key);

  @override
  _NewPlantPageState createState() => _NewPlantPageState();
}

class _NewPlantPageState extends State<NewPlantPage> {
  DateTime? _selectedDate;
  final _cropDecController = TextEditingController();
  final _cropCompanyController = TextEditingController();
  final _cropPlotController = TextEditingController();
  final _cropHarvestController = TextEditingController();
  final _cropDropdownController = TextEditingController();
  final _fieldDropdownController = TextEditingController();
  final _seedTypeController = TextEditingController();

  List<String> _cropTypeList = [];
  List<String> _fieldList = [];

  @override
  void initState() {
    super.initState();
    _fetchCropTypes();
    _fetchFields();
  }

  Future<void> _fetchCropTypes() async {
    final crops = await DatabaseHelper.instance.getCrops();
    setState(() {
      _cropTypeList = crops.map((crop) => crop['name'] as String).toList();
    });
  }

  Future<void> _fetchFields() async {
    final fields = await DatabaseHelper.instance.getFields();
    setState(() {
      _fieldList = fields.map((field) => field['fieldName'] as String).toList();
    });
  }

  Future<void> _navigateToAddCropPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewCropPage()),
    );

    if (result == true) {
      _fetchCropTypes();
    }
  }

  Future<void> _navigateToAddFieldPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewFieldPage(
          onAdd: (fieldData) {
            setState(() {
              _fieldList.add(fieldData['fieldName']);
            });
          },
        ),
      ),
    );

    if (result == true) {
      _fetchFields();
    }
  }

  @override
  void dispose() {
    _cropDecController.dispose();
    _cropCompanyController.dispose();
    _cropPlotController.dispose();
    _cropHarvestController.dispose();
    _cropDropdownController.dispose();
    _fieldDropdownController.dispose();
    _seedTypeController.dispose();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Planting',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Select a date',
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.green),
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
              ),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField(
              value: _cropDropdownController.text.isNotEmpty ? _cropDropdownController.text : null,
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
              icon: const Icon(Icons.arrow_drop_down_outlined, color: Colors.green),
              decoration: const InputDecoration(
                labelText: "Select crop",
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _navigateToAddCropPage,
              child: const Text('Add New Crop', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: _fieldDropdownController.text.isNotEmpty ? _fieldDropdownController.text : null,
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
                    icon: const Icon(Icons.arrow_drop_down_outlined, color: Colors.green),
                    decoration: const InputDecoration(
                      labelText: "Select field",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  tooltip: 'Add New Field',
                  onPressed: _navigateToAddFieldPage,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _seedTypeController,
              fieldName: "Seed type",
              myIcon: Icons.grass,
              prefixIconColor: Colors.green,
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropDecController,
              fieldName: "Seed quantity",
              myIcon: Icons.format_list_numbered,
              prefixIconColor: Colors.green,
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropCompanyController,
              fieldName: "Seed company",
              myIcon: Icons.business,
              prefixIconColor: Colors.green,
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropPlotController,
              fieldName: "Seed plot number",
              myIcon: Icons.map,
              prefixIconColor: Colors.green,
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _cropHarvestController,
              fieldName: "Estimated harvest",
              myIcon: Icons.agriculture,
              prefixIconColor: Colors.green,
            ),
            const SizedBox(height: 20.0),
            myBtn(context),
          ],
        ),
      ),
    );
  }

  OutlinedButton myBtn(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: const BorderSide(color: Colors.green, width: 2),
      ),
      onPressed: () async {
        Map<String, dynamic> plantingData = {
          'date': _selectedDate != null ? '${_selectedDate!.toLocal()}'.split(' ')[0] : '',
          'crop': _cropDropdownController.text,
          'field': _fieldDropdownController.text,
          'description': _cropDecController.text,
          'cropCompany': _cropCompanyController.text,
          'cropType': _cropDropdownController.text,
          'cropPlotNumber': _cropPlotController.text,
          'cropHarvest': _cropHarvestController.text,
          'seedType': _seedTypeController.text,
        };

        await DatabaseHelper.instance.insertPlanting(plantingData);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Details(
              cropCompany: _cropCompanyController.text,
              cropType: _cropDropdownController.text,
              cropPlotNumber: _cropPlotController.text,
              cropHarvest: _cropHarvestController.text,
              seedType: _seedTypeController.text,
              cropName: '',
            );
          }),
        );
      },
      icon: const Icon(Icons.add, color: Colors.green),
      label: const Text("Add", style: TextStyle(color: Colors.black)),
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
    this.inputType = TextInputType.text,
  }) : super(key: key);

  final TextEditingController myController;
  final String fieldName;
  final IconData myIcon;
  final Color prefixIconColor;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: fieldName,
        prefixIcon: Icon(myIcon, color: prefixIconColor),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade300),
        ),
      ),
    );
  }
}
