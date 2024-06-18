import 'package:farm_records_management_system/plant/main_page.dart';
import 'package:farm_records_management_system/screens/harvest_add.dart';
import 'package:farm_records_management_system/screens/home_screen.dart';
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
                          MaterialPageRoute(builder: (context) =>const MainPage()));
                    },
                    child: const PlantingCard(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HarvestListScreen()));
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
                          MaterialPageRoute(builder: (context) =>const MyHomePage(farmer: {},)));
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
