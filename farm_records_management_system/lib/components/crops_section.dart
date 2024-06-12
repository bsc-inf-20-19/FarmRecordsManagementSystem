import 'package:farm_records_management_system/screens/activity_screen.dart';
import 'package:farm_records_management_system/widgets/crops/activity/activity_card.dart';
import 'package:farm_records_management_system/widgets/crops/activity/crop_list_card.dart';
import 'package:flutter/material.dart';

class CropsSection extends StatelessWidget {
  const CropsSection({super.key});

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
                          MaterialPageRoute(builder: (context) => const ActivityPage()));
                    },
                    child: const CropListCard(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const ActivityPage()));
                    },
                    child: const ActivityCard(),
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
