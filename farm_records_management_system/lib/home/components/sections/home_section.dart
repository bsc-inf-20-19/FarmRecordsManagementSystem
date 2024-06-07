import 'package:farm_records_management_system/home/screens/fields_screen.dart';
import 'package:farm_records_management_system/home/screens/report_screen.dart';
import 'package:farm_records_management_system/home/screens/trans_screen.dart';
import 'package:farm_records_management_system/home/widgets/field_card.dart';
import 'package:farm_records_management_system/home/widgets/report_card.dart';
import 'package:farm_records_management_system/home/widgets/setup_card.dart';
import 'package:farm_records_management_system/home/widgets/trans_card.dart';
import 'package:farm_records_management_system/home/widgets/go_premium_widget.dart';
import 'package:flutter/material.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      
      child: ListView(
        children: [
          Container(
            height: 200,
            child: Row(
              children: [
                InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FieldScreen()
                    )
                  );
                },
               child: FieldsCard(),
              ),
                InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Transview()
                    )
                  );
                },
               child: TransCard(),
              ),
              ]
            )
          ),
          Container(
            height: 200,
            child: Row(
              children: [
                InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportView()
                    )
                  );
                },
               child: ReportCard(),
              ),
                InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoPremium()
                    )
                  );
                },
               child: SetupCard(),
              ),
              ]
            )
          )
        
        ]
      )
      );
  }
}
