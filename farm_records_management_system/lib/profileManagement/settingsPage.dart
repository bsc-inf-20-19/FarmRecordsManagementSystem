import 'package:farm_records_management_system/profileManagement/appBarWidget.dart';
import 'package:farm_records_management_system/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
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
              'Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            Text('Guidelines on how to set up and use the system.'),
            // Add more settings and guidelines
          ],
        ),
      ),
      drawer: DrawerWidget(farmer: {},), // Assuming DrawerWidget can handle null farmer
    );
  }
}
