import 'package:farm_records_management_system/profileManagement/appBarWidget.dart';
import 'package:farm_records_management_system/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class MyAccountPage extends StatelessWidget {
  final Map<String, dynamic> farmer;

  const MyAccountPage({super.key, required this.farmer});

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
              'Account Details',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            Text('Name: ${farmer['firstName']} ${farmer['lastName']}'),
            Text('Email: ${farmer['email']}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality to update account details
              },
              child: const Text('Update Account Details'),
            ),
          ],
        ),
      ),
      drawer: DrawerWidget(farmer: {},),
    );
  }
}
