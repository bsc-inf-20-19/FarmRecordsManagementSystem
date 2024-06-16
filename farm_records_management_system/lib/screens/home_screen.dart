import 'package:flutter/material.dart';
import 'package:farm_records_management_system/components/home_section.dart';
import 'package:farm_records_management_system/widgets/appbar_widget.dart';
import 'package:farm_records_management_system/widgets/drawer_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:Color(0xFFF5F5DC),
      body: Stack(
        children: [
          // Content with gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Color.fromARGB(255, 97, 204, 82), // Start color (green)
                  Colors.white, // End color (white)
                ],
              ),
            ),
            child: Column(
              children: [
                AppBarWidget(),
                Expanded(child: HomeSection()),
              ],
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
    );
  }
}
