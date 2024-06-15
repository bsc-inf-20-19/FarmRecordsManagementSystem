import 'package:farm_records_management_system/screens/crop_screen.dart';
import 'package:farm_records_management_system/screens/livestock_screen.dart';
import 'package:farm_records_management_system/screens/trans_screen.dart';
import 'package:farm_records_management_system/widgets/crop_card.dart';
import 'package:farm_records_management_system/widgets/livestock_card.dart';
import 'package:flutter/material.dart';

class FieldSection extends StatelessWidget {
  const FieldSection({super.key});

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
                      builder: (context) =>  CropsFieldPage()
                    )
                  );
                },
               child: CropCard(),
              ),
                InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LivestockScreen(),
                    )
                  );
                },
               child: LivestockCard(),
              ),
              ]
            )
          ),
        ]
      )
      );
  }
}
