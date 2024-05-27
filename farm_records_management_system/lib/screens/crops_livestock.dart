import 'package:farm_records_management_system/Pages/activity_page.dart';
import 'package:farm_records_management_system/screens/home_page.dart';
import 'package:flutter/material.dart';

class CropsLivestockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 16, 83, 8),
        body: LandingPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Crops and Livestock'),
        titleTextStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 20),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardItem(
                  title: 'Crops',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyActivityPage()),
                    );
                  },
                ),
                CardItem(
                  title: 'Livestock',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CropsPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
