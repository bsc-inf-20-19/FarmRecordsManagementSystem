import 'package:farm_records_management_system/screens/home_screen.dart';
import 'package:farm_records_management_system/screens/new_planting.dart';
import 'package:farm_records_management_system/screens/treatments.dart';
import 'package:farm_records_management_system/widgets/crops/activity/harvest_card.dart';
import 'package:farm_records_management_system/widgets/crops/activity/planting_card.dart';
import 'package:farm_records_management_system/widgets/crops/activity/tasks_card.dart';
import 'package:farm_records_management_system/widgets/crops/activity/treatment_card.dart';
import 'package:flutter/material.dart';

class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: ListView(children: [
          Container(
              height: 200,
              child: Row(children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewPlantPage()));
                  },
                  child: PlantingCard(),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  child: HarvestCard(),
                ),
              ])),
          Container(
              height: 200,
              child: Row(children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TreatmentsPage()));
                  },
                  child: TreatmentCard(),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  child: TasksCard(),
                ),
              ]))
        ]));
  }
}
