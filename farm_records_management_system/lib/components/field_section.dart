import 'package:farm_records_management_system/screens/crop_screen.dart'; // Assuming CropScreen exists
import 'package:farm_records_management_system/screens/fieldScreen.dart';
import 'package:farm_records_management_system/widgets/crop_card.dart';
import 'package:farm_records_management_system/widgets/fieldCard.dart';
import 'package:flutter/material.dart';

class FieldSection extends StatelessWidget {
  const FieldSection({Key? key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
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
                            builder: (context) => const CropsFieldPage(), // Assuming CropsFieldPage exists
                          ),
                        );
                      },
                      child: const CropCard(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FieldListScreen(), // Corrected to FieldListScreen
                          ),
                        );
                      },
                      child: FieldCard(
                        fieldData: {}, // Provide actual field data here
                        onTap: () {
                          // Example implementation of onTap
                          // Navigates to a specific screen when the card is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FieldListScreen(), // Assuming FieldDetailsScreen exists
                            ),
                          );
                        },
                    ),
                  ),
                  ),
                ],
              ),
            ),
            // Additional content can be added here if needed
          ],
        ),
      ),
    );
  }
}
