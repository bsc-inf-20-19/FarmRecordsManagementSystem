import 'package:farm_records_management_system/Pages/transaction/transactions.dart';
import 'package:farm_records_management_system/screens/fields_screen.dart';
import 'package:farm_records_management_system/screens/home_screen.dart';
import 'package:farm_records_management_system/widgets/field_card.dart';
import 'package:farm_records_management_system/widgets/report_card.dart';
import 'package:farm_records_management_system/widgets/setup_card.dart';
import 'package:farm_records_management_system/widgets/trans_card.dart';
import 'package:flutter/material.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
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
                        MaterialPageRoute(builder: (context) => const TransactionPage()),
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
                        MaterialPageRoute(builder: (context) => const MyHomePage()), // Navigate to Report Screen
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
                        MaterialPageRoute(builder: (context) => const MyHomePage()), // Navigate to Setup Screen
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
