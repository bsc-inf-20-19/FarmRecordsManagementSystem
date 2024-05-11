import 'package:farm_records_management_system/Pages/activity_page.dart';
import 'package:flutter/material.dart';

class Activity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 16, 83, 8),
        body: ActivityLandingPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ActivityLandingPage extends StatelessWidget {
  const ActivityLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // Change background color here
          title: const Text('Farm crop activities'),
          titleTextStyle:
              const TextStyle(fontStyle: FontStyle.normal, fontSize: 20),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardItem(
                            title: 'Activities',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyActivityPage()),
                              );
                            }),   
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
