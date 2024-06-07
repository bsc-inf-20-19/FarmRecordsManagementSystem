import 'package:flutter/material.dart';

class Transview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Icon(Icons.more_vert),
              ],
            ),
            SizedBox(height: 8),
            SummaryItem(
              label: 'Total Income',
              value: '\$180.00',
              color: Colors.green,
              icon: Icons.attach_money,
            ),
            SummaryItem(
              label: 'Total Expenses',
              value: '\$25.00',
              color: Colors.red,
              icon: Icons.money_off,
            ),
            SummaryItem(
              label: 'Total Credit Limit',
              value: '\$25.00',
              color: Colors.red,
              icon: Icons.credit_card,
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  SummaryItem({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 8),
          Text(label),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
