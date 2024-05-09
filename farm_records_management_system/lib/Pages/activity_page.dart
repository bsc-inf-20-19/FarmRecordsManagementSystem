// import 'package:farm_records_management_system/Pages/crop.dart';
import 'package:farm_records_management_system/Pages/fields.dart';
import 'package:flutter/material.dart';
import 'package:farm_records_management_system/pages/tasks.dart';
import 'package:farm_records_management_system/Pages/treatments.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farm Record',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
      ),
      home: const MyHomePage(title: 'Farm Record'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white, // background color
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TreatmentsPage()));
                    },
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // minus 32 due to the margin
                      margin: const EdgeInsets.all(14.0),
                      padding: const EdgeInsets.all(14.0),
                      decoration: const BoxDecoration(
                        color: Colors.white, // background color of the cards
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          // this is the shadow of the card
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // posion the everything to the bottom
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // place here your image
                          Text("Treatments",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const TasksPage()));
                    },
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // minus 32 due to the margin
                      margin: const EdgeInsets.all(14.0),
                      padding: const EdgeInsets.all(14.0),
                      decoration: const BoxDecoration(
                        color: Colors.white, // background color of the cards
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          // this is the shadow of the card
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // posion the everything to the bottom
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // place here your image
                          Text("Tasks",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FieldsPage()));
                    },
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 2 -
                          32, // minus 32 due to the margin
                      margin: const EdgeInsets.all(14.0),
                      padding: const EdgeInsets.all(14.0),
                      decoration: const BoxDecoration(
                        color: Colors.white, // background color of the cards
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          // this is the shadow of the card
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // posion the everything to the bottom
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // place here your image
                          Text("Field",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
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

  const CardItem({super.key, required this.title, required this.onTap});

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
