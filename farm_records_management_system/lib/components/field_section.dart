import 'package:farm_records_management_system/Pages/fieldListScreen.dart';
import 'package:farm_records_management_system/home/utils/styles.dart';
import 'package:farm_records_management_system/screens/crop_screen.dart';
import 'package:farm_records_management_system/widgets/crop_card.dart';
import 'package:farm_records_management_system/widgets/fieldCard.dart';
import 'package:flutter/material.dart';

class FieldSection extends StatelessWidget {
  const FieldSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container( 
        padding: const EdgeInsets.all(8.0),
        color:Color(0xc7c7c7),
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
                  Expanded(
                    child: InkWell(
                      onTap: () => {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const FieldListScreen())
                        )
                      },
                      child: const FieldCard(),
                    )
                 )
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
