import 'package:farm_records_management_system/screens/farm_tools_screen.dart';
import 'package:farm_records_management_system/screens/fields_screen.dart';
import 'package:farm_records_management_system/screens/report_screen.dart';
import 'package:farm_records_management_system/screens/trans_screen.dart';
import 'package:farm_records_management_system/widgets/field_card.dart';
import 'package:farm_records_management_system/widgets/report_card.dart';
import 'package:farm_records_management_system/widgets/tools_card.dart';
import 'package:farm_records_management_system/widgets/trans_card.dart';
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
                      builder: (context) => TransactionListScreen()
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
                      builder: (context) => ReportScreen()
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
                      builder: (context) => FarmToolsPage(),
                    )
                  );
                },
               child: ToolsCard(),
              ),
              ]
            )
          )
        
        ]
      )
      );
  }
}
