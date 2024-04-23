import 'package:flutter/material.dart';
import 'package:farm_records_management_system/pages/tasks.dart';
import 'package:farm_records_management_system/Pages/treatments.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farm Record',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
        ),
      ),
      home: MyHomePage(title: 'Farm Record'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Card Item for Treatments
                  CardItem(
                    title: 'Treatments',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TreatmentsPage()),
                      );
                    },
                  ),
                  CardItem(
                    title: 'Tasks',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TasksPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CardItem({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: 150,
          width: 150,
          alignment: Alignment.center,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }
}
