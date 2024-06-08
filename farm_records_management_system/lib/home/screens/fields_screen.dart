import 'package:farm_records_management_system/home/components/sections/field_section.dart';
import 'package:farm_records_management_system/home/widgets/fieldbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FieldScreen extends StatelessWidget {
  const FieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          FieldBarWidget(),
          //Field Section Widget
          FieldSection(),
        ],
      ),
    );
  }
}

