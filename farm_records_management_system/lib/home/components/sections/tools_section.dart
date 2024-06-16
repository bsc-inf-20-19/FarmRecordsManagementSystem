import 'package:farm_records_management_system/home/screens/home_screen.dart';
import 'package:farm_records_management_system/home/screens/report_screen.dart';
import 'package:farm_records_management_system/home/widgets/equipment_card.dart';
import 'package:farm_records_management_system/home/widgets/inventory_card.dart';
import 'package:flutter/material.dart';

class ToolsSection extends StatelessWidget {
  const ToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      
      child: ListView(
        children: [
          Container(
            height: 200,
            child: Row(
              children: [
                InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportScreen()
                    )
                  );
                },
               child: InventoryCard(),
              ),
                InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    )
                  );
                },
               child: EquipmentCard(),
              ),
              ]
            )
          )
        ]
      )
      );
  }
}
