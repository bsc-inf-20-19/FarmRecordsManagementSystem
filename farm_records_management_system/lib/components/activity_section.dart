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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>const NewPlantPage()));
                    },
                    child: const PlantingCard(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const MyHomePage()));
                    },
                    child:const HarvestCard(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const TreatmentsPage()));
                    },
                    child: const TreatmentCard(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>const MyHomePage()));
                    },
                    child:const TasksCard(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
