import 'package:farm_records_management_system/components/set-up_section.dart';
import 'package:farm_records_management_system/screens/fields_screen.dart';
import 'package:farm_records_management_system/screens/home_screen.dart';
import 'package:farm_records_management_system/transaction/manage_transaction.dart';
import 'package:farm_records_management_system/transaction/report_screen.dart';
import 'package:farm_records_management_system/widgets/field_card.dart';
import 'package:farm_records_management_system/widgets/report_card.dart';
import 'package:farm_records_management_system/widgets/setup_card.dart';
import 'package:farm_records_management_system/widgets/trans_card.dart';
import 'package:flutter/material.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key, required Map<String, dynamic> farmer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xc7c7c7),
      body: Container(
        padding: const EdgeInsets.all(8.0), // Light Blue color
        color:  Color(0xc7c7c7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FieldScreen()),
                      );
                    },
                    child:const FieldsCard(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ManageTransactionsScreen(farmerID: 1,)),
                      );
                    },
                    child:const TransCard(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ReportScreen()),
                      );
                    },
                    child:const ReportCard(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SetUpPage()) // Navigate to Setup Screen
                      );
                    },
                    child:const SetupCard(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
