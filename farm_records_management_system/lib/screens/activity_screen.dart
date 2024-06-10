import 'package:farm_records_management_system/components/activity_section.dart';
import 'package:farm_records_management_system/widgets/crops/activity/activity_bar.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key, required plantingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          ActivityBarWidget(),
          //Activities
          ActivitySection(),
        ],
      ),
    );
  }
}
