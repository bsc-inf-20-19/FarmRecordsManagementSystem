
import 'package:farm_records_management_system/home/components/sections/home_section.dart';
import 'package:farm_records_management_system/home/widgets/drawer_widget.dart';
import 'package:farm_records_management_system/home/widgets/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          AppBarWidget(),

          //Search bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 3))
                  ]),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.search,
                      color: Color(0xFF3388E3C),
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: "Search farm...",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          //Home Cards
          HomeSection()
        ],
      ),
      drawer: DrawerWidget(),
    );
  }
}

