
import 'package:farm_records_management_system/home/components/sections/home_section.dart';
import 'package:farm_records_management_system/home/widgets/drawer_widget.dart';
import 'package:farm_records_management_system/home/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required Map<String, dynamic> farmer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          AppBarWidget(),
          SizedBox(height: 20,),
          
          SizedBox(height: 20,),
          //Home Cards
          HomeSection()
        ],
      ),
      drawer: DrawerWidget(),
    );
  }
}

