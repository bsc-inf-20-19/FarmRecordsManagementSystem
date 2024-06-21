
import 'package:farm_records_management_system/home/components/sections/tools_section.dart';
import 'package:farm_records_management_system/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class FarmToolsPage extends StatelessWidget {
  const FarmToolsPage({Key? key}) : super(key: key);

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
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Farm Tools'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          
          SizedBox(height: 20,),
          //Home Cards
          ToolsSection()
        ],
      ),
      drawer: DrawerWidget(farmer: {},),
    );
  }
}

