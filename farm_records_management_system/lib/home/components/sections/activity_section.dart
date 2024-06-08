import 'package:farm_records_management_system/home/components/forms/addCrop.dart';
import 'package:farm_records_management_system/home/screens/add_harvest_page.dart';
import 'package:farm_records_management_system/home/components/sections/task_section.dart';
import 'package:farm_records_management_system/home/screens/harvests_view.dart';
import 'package:farm_records_management_system/home/widgets/crops/activity/harvest_card.dart';
import 'package:farm_records_management_system/home/widgets/crops/activity/planting_card.dart';
import 'package:farm_records_management_system/home/widgets/crops/activity/tasks_card.dart';
import 'package:farm_records_management_system/home/widgets/crops/activity/treatment_card.dart';
import 'package:flutter/material.dart';

class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

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
                      builder: (context) => AddCropPage()
                    )
                  );
                },
               child: PlantingCard(),
              ),
                InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HarvestsViewPage()
                    )
                  );
                },
               child: HarvestCard(),
              ),
              ]
            )
          ),
          Container(
            height: 200,
            child: Row(
              children: [
                InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FarmTaskPage()
                    )
                  );
                },
               child: TreatmentCard(),
              ),
                InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FarmTaskPage()
                    )
                  );
                },
               child: TasksCard(),
              ),
              ]
            )
          )
        
        ]
      )
      );
  }
}
