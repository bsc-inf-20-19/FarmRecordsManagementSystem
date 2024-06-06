import 'package:flutter/material.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';

class FieldListPage extends StatelessWidget {
  const FieldListPage({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchFields() async {
    return await DatabaseHelper.getFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fields List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchFields(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No fields found.'));
          } else {
            final fields = snapshot.data!;
            return ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                final field = fields[index];
                return ListTile(
                  title: Text(field['fieldName']),
                  subtitle: Text('Type: ${field['fieldType']}, Size: ${field['fieldSize']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
