import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Farm Records Management System (FRMS)',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 16),
            Text(
              'The Farm Records Management System (FRMS) is a mobile application designed to digitise and simplify the process of recording and managing farm-related data. It aims to help farmers in Malawi, to transition from paper-based or memory-based record keeping to a digital platform. The application will allow farmers to record and track essential information related to their farms, crops, livestock and agricultural activities.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 32),
            Text(
              'The Team Behind FRMS',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            teamMemberCard(
              context,
              name: 'Mphatso Mphepo',
              role: 'Lead Developer (Frontend)',
            ),
            teamMemberCard(
              context,
              name: 'Harold Mvula',
              role: 'Project Manager',
            ),
            teamMemberCard(
              context,
              name: 'Ephraim Phiri',
              role: 'Backend Developer and Monitoring and Evaluator',
            ),
            teamMemberCard(
              context,
              name: 'Elvis Magugu',
              role: 'UX Designer and Developer',
            ),
          ],
        ),
      ),
    );
  }

  Widget teamMemberCard(BuildContext context, {required String name, required String role}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            name[0],
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        title: Text(
          name,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Text(role),
      ),
    );
  }
}
