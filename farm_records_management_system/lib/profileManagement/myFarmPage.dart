import 'package:farm_records_management_system/profileManagement/appBarWidget.dart';
import 'package:farm_records_management_system/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class MyFarmPage extends StatelessWidget {
  final Map<String, dynamic> farmer;

  const MyFarmPage({super.key, required this.farmer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Farm Overview',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            // Display farm details
            Text('Farm Name: ${farmer['farmName'] ?? 'Not Set'}'),
            // Add more farm details
          ],
        ),
      ),
      drawer: DrawerWidget(farmer: {},),
    );
  }
}
