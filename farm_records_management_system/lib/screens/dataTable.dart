import 'package:flutter/material.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return SingleChildScrollView(
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
                  rows: _buildRows(snapshot.data!),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    List<Map<String, dynamic>> transactions = await DatabaseHelper.instance.getTransactions();
    List<Map<String, dynamic>> harvests = await DatabaseHelper.instance.getHarvests();

    List<Map<String, dynamic>> combinedData = [];

    transactions.forEach((transaction) {
      combinedData.add({
        'date': transaction['date'],
        'field': transaction['field'],
        'crop': transaction['crop'],
        'quantity': transaction['quantity'],
        'expense': transaction['expense'],
        'income': transaction['income'],
        'balance': transaction['balance'],
      });
    });

    harvests.forEach((harvest) {
      combinedData.add({
        'date': harvest['date'],
        'field': harvest['field'],
        'crop': harvest['cropList'],
        'quantity': harvest['harvestQuantity'],
        'expense': 0.0, // Assuming there's no expense in harvest data
        'income': harvest['harvestIncome'],
        'balance': 0.0, // Placeholder, you can calculate the actual balance if needed
      });
    });

    return combinedData;
  }

  List<DataRow> _buildRows(List<Map<String, dynamic>> data) {
    return data.map((item) {
      return DataRow(
        cells: [
          DataCell(Text(item['date'].toString())),
          DataCell(Text(item['field'].toString())),
          DataCell(Text(item['crop'].toString())),
          DataCell(Text(item['quantity'].toString())),
          DataCell(Text(item['expense'].toString())),
          DataCell(Text(item['income'].toString())),
          DataCell(Text(item['balance'].toString())),
        ],
      );
    }).toList();
  }
}
