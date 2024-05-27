import 'package:farm_records_management_system/Pages/activity_page.dart';
import 'package:farm_records_management_system/Pages/home.dart';
// import 'package:farm_records_management_system/screens/Activities.dart';
import 'package:farm_records_management_system/screens/new_planting.dart';
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
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // Change background color here
          title: const Text('Crops and Livestock'),
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
                            title: 'Crops',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActivityPage()),
                              );
                            }),

                         CardItem(
                            title: 'Livestock',
                            onTap: () => {
                                Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                   CropsPage()
                              ),
                                )
                            },
                            
                           )   
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
