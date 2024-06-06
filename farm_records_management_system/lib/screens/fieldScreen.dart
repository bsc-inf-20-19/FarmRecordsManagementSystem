import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/widgets/fieldCard.dart';
import 'package:flutter/material.dart';

class FieldListScreen extends StatefulWidget {
  const FieldListScreen({Key? key}) : super(key: key);

  @override
  _FieldListScreenState createState() => _FieldListScreenState();
}

class _FieldListScreenState extends State<FieldListScreen> {
  List<Map<String, dynamic>> fields = [];

  @override
  void initState() {
    super.initState();
    _fetchFields();
  }

  void _fetchFields() async {
    List<Map<String, dynamic>> fetchedFields = await DatabaseHelper.getFields();
    setState(() {
      fields = fetchedFields;
    });
  }

  void _navigateToFieldDetail(Map<String, dynamic> fieldData) {
    // Navigate to a detailed screen for the field (implement this screen if needed)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fields'),
      ),
      body: ListView.builder(
        itemCount: fields.length,
        itemBuilder: (context, index) {
          return FieldCard(
            fieldData: fields[index],
            onTap: () => _navigateToFieldDetail(fields[index]),
          );
        },
      ),
    );
  }
}
