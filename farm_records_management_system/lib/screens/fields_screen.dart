import 'package:farm_records_management_system/components/sections/field_section.dart';
import 'package:farm_records_management_system/widgets/fieldbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FieldScreen extends StatelessWidget {
  const FieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Change icon color to white
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Change title text color to white
        leading: IconButton(
           onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Back',
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Fields'),
        centerTitle: true,
      ),
      
      body: ListView(
        children: [
          //Field Section Widget
          FieldSection(),
        ],
      ),
    );
  }
}

