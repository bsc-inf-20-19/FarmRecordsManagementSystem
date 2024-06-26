import 'package:flutter/material.dart';
import 'package:farm_records_management_system/screens/home_screen.dart';

class FieldBarWidget extends StatelessWidget {
  const FieldBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0, // No shadow
      leading: InkWell(
        onTap: () {
          Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(farmer: {},),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        "My Field",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.notifications),
          ),
        ),
      ],
    );
  }
}
