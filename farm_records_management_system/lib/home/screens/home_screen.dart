
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search farm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    // Handle filter button press
                  },
                ),
              ],
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

