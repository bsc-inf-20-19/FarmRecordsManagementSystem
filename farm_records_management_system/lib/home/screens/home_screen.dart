
import 'package:farm_records_management_system/home/components/sections/home_section.dart';
import 'package:farm_records_management_system/home/widgets/drawer_widget.dart';
import 'package:farm_records_management_system/home/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
            //handle menu
          },
          tooltip: 'Back',
          icon: Icon(Icons.menu),
        ),
        title: Text('Farm Manager'),
        centerTitle: true,
      ),
      body: ListView(
        children: [          
          SizedBox(height: 20,),
          //Home Cards
          HomeSection()
        ],
      ),
      drawer: DrawerWidget(),
    );
  }
}

