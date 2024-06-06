import 'package:flutter/material.dart';

class FieldCard extends StatelessWidget {
  final Map<String, dynamic> fieldData;
  final VoidCallback onTap;

  const FieldCard({required this.fieldData, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(fieldData['field_name'] ?? 'No Name'),
        subtitle: Text(fieldData['field_type'] ?? 'No Type'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
