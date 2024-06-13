import 'package:farm_records_management_system/home/components/sections/livestock_section.dart';
import 'package:flutter/material.dart';

class LiveStockScreen extends StatelessWidget {
  const LiveStockScreen({super.key});

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
        title: Text('Livestocks'),
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
          //Livestock section here
          LivestockSection(),
        ],
      ),
    );
  }
}
