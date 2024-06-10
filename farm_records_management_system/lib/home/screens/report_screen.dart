import 'package:flutter/material.dart';

class ReportView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop List'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('MAY 2019')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    '\$23.00',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Current Balance',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SummarySection(),
            IncomeSection(),
            ExpensesSection(),
          ],
        ),
      ),
    );
  }
}

class SummarySection extends StatelessWidget {
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
            Divider(thickness: .5, color: Colors.black54),
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

class ExpensesSection extends StatelessWidget {
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
                  'Expenses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Icon(Icons.more_vert),
              ],
            ),
            Divider(thickness: .5, color: Colors.black54),
            SizedBox(height: 8),
            ExpensesItem(
              label: 'Outstanding Expenses',
              value: '\$180.00',
              color: Colors.red,
              icon: Icons.money_off,
            ),
            ExpensesItem(
              label: 'Outstanding Expenses',
              value: '\$25.00',
              color: Colors.red,
              icon: Icons.money_off,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpensesItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  ExpensesItem({required this.label, required this.value, required this.color, required this.icon});

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



class IncomeSection extends StatelessWidget {
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
                  'Income',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Icon(Icons.more_vert),
              ],
            ),
            Divider(thickness: .5, color: Colors.black54),
            SizedBox(height: 8),
            IncomeItem(
              label: 'Outstanding Income',
              value: '\$180.00',
              color: Colors.green,
              icon: Icons.attach_money_outlined,
            ),
            IncomeItem(
              label: 'Outstanding Income',
              value: '\$25.00',
              color: Colors.green,
              icon: Icons.attach_money_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class IncomeItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  IncomeItem({required this.label, required this.value, required this.color, required this.icon});

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

