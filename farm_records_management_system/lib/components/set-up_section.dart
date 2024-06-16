import 'package:farm_records_management_system/widgets/expense_card.dart';
import 'package:farm_records_management_system/widgets/income_card.dart';
import 'package:flutter/material.dart';

class SetUpPage extends StatelessWidget {
  const SetUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farm Set Up',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
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
                        MaterialPageRoute(builder: (context) => const SetUpPage()),
                      );
                    },
                    child: const IncomeCard(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SetUpPage()),
                      );
                    },
                    child: const ExpenseCard(),
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
