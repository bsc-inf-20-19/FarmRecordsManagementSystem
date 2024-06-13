import 'package:farm_records_management_system/home/components/sections/crops_section.dart';
import 'package:flutter/material.dart';

class CropsFieldPage extends StatelessWidget {
  const CropsFieldPage({super.key});

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
        title: Text('Farm Tools'),
        centerTitle: true,
        actions:[
          IconButton(
            onPressed: () {}, 
            tooltip: 'Search',
          icon: Icon(Icons.search),
          )
        ],
      ),
      
      body: ListView(
        children: [
          //Crop section here
          CropsSection(),
        ],
      ),
    );
  }
}
