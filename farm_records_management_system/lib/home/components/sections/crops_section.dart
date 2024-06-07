import 'package:farm_records_management_system/home/components/forms/addCrop.dart';
import 'package:farm_records_management_system/home/screens/activity_screen.dart';
import 'package:farm_records_management_system/home/components/details/notes.dart';
import 'package:farm_records_management_system/home/widgets/crops/activity/activity_card.dart';
import 'package:farm_records_management_system/home/widgets/crops/activity/crop_list_card.dart';
import 'package:flutter/material.dart';

class CropsSection extends StatelessWidget {
  const CropsSection({super.key});

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
                      builder: (context) => FarmNotesPage()
                    )
                  );
                },
               child: CropListCard(),
              ),
                InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityPage()
                    )
                  );
                },
               child: ActivityCard(),
              ),
              ]
            )
          ),
        ]
      )
      );
  }
}
