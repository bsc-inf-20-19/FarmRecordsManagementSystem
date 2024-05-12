// import 'package:farm_records_management_system/Pages/crop.dart';
import 'package:farm_records_management_system/Pages/fields.dart';
import 'package:farm_records_management_system/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:farm_records_management_system/pages/tasks.dart';
import 'package:farm_records_management_system/Pages/treatments.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: MyActivityPage(),
    );
  }
}

class MyActivityPage extends StatelessWidget {
 
const MyActivityPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
       return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // Change background color here
          title: const Text('Activities'),
          titleTextStyle:
              const TextStyle(fontStyle: FontStyle.normal, fontSize: 20),
          centerTitle: true,
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                        MaterialPageRoute(builder: (context) => FieldsPage()),
                      );
                    },
                  ),
                  CardItem(
                    title: 'Plantings', // New navigation option
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CropsPage()),
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
