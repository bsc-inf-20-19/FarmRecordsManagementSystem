import 'package:farm_records_management_system/screens/crop_screen.dart'; // Assuming CropScreen exists
import 'package:farm_records_management_system/widgets/crop_card.dart';
import 'package:farm_records_management_system/widgets/livestock_card.dart';
import 'package:flutter/material.dart';

class FieldSection extends StatelessWidget {
  const FieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CropsFieldPage(), // Assuming CropsFieldPage exists
                        ),
                      );
                    },
                    child: CropCard(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CropsFieldPage(), // Assuming CropsFieldPage exists
                        ),
                      );
                    },
                    child: LivestockCard(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
