import 'package:flutter/material.dart';
import 'package:farm_records_management_system/components/field_section.dart';
import 'package:farm_records_management_system/widgets/fieldbar_widget.dart';

class FieldScreen extends StatelessWidget {
  const FieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          FieldBarWidget(),
           const FieldSection(),
        ],
      ),
    );
  }
}
