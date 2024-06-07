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
            AlertsSection(),
            AccountsSection(),
            CropSection(),
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

class AlertsSection extends StatelessWidget {
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
                  'Alerts',
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
            AlertItem(
              label: 'Outstanding Income',
              value: '\$180.00',
              color: Colors.orange,
              icon: Icons.warning,
            ),
            AlertItem(
              label: 'Outstanding Expenses',
              value: '\$25.00',
              color: Colors.orange,
              icon: Icons.warning,
            ),
          ],
        ),
      ),
    );
  }
}

class AlertItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  AlertItem({required this.label, required this.value, required this.color, required this.icon});

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

class AccountsSection extends StatelessWidget {
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
                  'Accounts',
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
            AccountItem(
              label: 'Amex(D)',
              value: '\$23.00',
              icon: Icons.account_balance_wallet,
            ),
            AccountItem(
              label: 'chase(Q)',
              value: '\$144.00',
              icon: Icons.account_balance_wallet,
            ),
          ],
        ),
      ),
    );
  }
}

class AccountItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  AccountItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 8),
          Text(label),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CropSection extends StatelessWidget {
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
                  'Crop Section',
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
            CropItem(label: 'Planting Date', value: 'March 15, 2024'),
            CropItem(label: 'Crop Name', value: 'Corn'),
            CropItem(label: 'Seed Quantity', value: '50 kg'),
            CropItem(label: 'Estimated Harvest', value: 'July 30, 2024'),
            CropItem(label: 'Seed Type', value: 'Hybrid'),
            CropItem(label: 'Seed Lot Number', value: 'H12345'),
            CropItem(label: 'Field Name', value: 'North Field'),
          ],
        ),
      ),
    );
  }
}

class CropItem extends StatelessWidget {
  final String label;
  final String value;

  CropItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
