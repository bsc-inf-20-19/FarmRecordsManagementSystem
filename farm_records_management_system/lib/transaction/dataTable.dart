import 'package:flutter/material.dart';


class ReportTableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('All Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.grid_on),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            columns: [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Field')),
              DataColumn(label: Text('Crop')),
              DataColumn(label: Text('Q-ty')),
              DataColumn(label: Text('Expense')),
              DataColumn(label: Text('Income')),
              DataColumn(label: Text('Balance')),
            ],
            rows: [
              _createDataRow('F1', 'Maize', '100Kg', '\$0.00', '\$0.00', '\$0.00'),
              _createDataRow('TOTAL:', '', '', '\$15.34', '\$54.00', '\$84.39'),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _createDataRow(String itemName, String qty, String amount, String expense, String income, String balance) {
    return DataRow(
      cells: [
        DataCell(Text(itemName)),
        DataCell(Text(qty)),
        DataCell(Text(amount)),
        DataCell(Text(expense)),
        DataCell(Text(income)),
        DataCell(Text(balance)),
      ],
    );
  }
}
