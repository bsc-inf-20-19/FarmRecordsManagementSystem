
import 'package:farm_records_management_system/components/sections/home_section.dart';
import 'package:farm_records_management_system/widgets/drawer_widget.dart';
import 'package:farm_records_management_system/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      toolbarHeight: 70,
       backgroundColor: Colors.green.shade500,
       shape: RoundedRectangleBorder(borderRadius: 
       BorderRadius.only(bottomLeft: Radius.circular(25),
       bottomRight: Radius.circular(25))
       ),
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
        actions: [
          IconButton(
            onPressed: () {
              //handle search
            },
            tooltip: 'Back',
            icon: Icon(Icons.search),
          ),
        ],
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

