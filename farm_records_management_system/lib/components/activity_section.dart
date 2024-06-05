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
          SizedBox(
              height: 200,
              child: Row(children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewPlantPage()));
                  },
                  child: const PlantingCard(),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const MyHomePage()));
                  },
                  child: const HarvestCard(),
                ),
              ])),
          SizedBox(
              height: 200,
              child: Row(children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TreatmentsPage()));
                  },
                  child: const TreatmentCard(),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const MyHomePage()));
                  },
                  child: const TasksCard(),
                ),
              ]))
        ]));
  }
}
