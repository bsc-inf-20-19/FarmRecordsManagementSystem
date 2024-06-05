import 'package:farm_records_management_system/utils/styles.dart';
import 'package:farm_records_management_system/components/home_section.dart';
import 'package:flutter/material.dart';

class MyActivityPage extends StatelessWidget {
  const MyActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: text,
                    borderRadius: BorderRadius.circular(100),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/aeneas.jpg'),
                    )),
                height: 50,
                width: 50,
              ),
              SizedBox(width: small),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Greetings', style: p1),
                  Text(
                    'Aeneas!',
                    style: heading3,
                  )
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Icon(
              Icons.notifications,
              color: icon,
              size: 28,
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 16),
          child: HomeSection(),
        ));
  }
}
