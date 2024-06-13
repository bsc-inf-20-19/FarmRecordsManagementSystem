import 'package:farm_records_management_system/components/crops_section.dart';
import 'package:flutter/material.dart';
import '../widgets/crops/activity/cropbar_widget.dart';

class CropsFieldPage extends StatelessWidget {
  const CropsFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          CropBarWidget(),
          // My Crop Section
          CropsSection(),
        ],
      ),
    );
  }
}
