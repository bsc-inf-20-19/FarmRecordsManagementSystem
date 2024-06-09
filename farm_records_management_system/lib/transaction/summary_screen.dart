import 'package:farm_records_management_system/project_trial/transaction/expense_DAO.dart';
import 'package:farm_records_management_system/project_trial/transaction/income_DAO.dart';
import 'package:flutter/material.dart';
import 'package:farm_records_management_system/project_trial/database_helper.dart';

class SummaryScreen extends StatefulWidget {
  final int farmerID;

  SummaryScreen({required this.farmerID});

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late Future<Map<String, dynamic>> _transactions;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  void _fetchTransactions() {
    setState(() {
      _transactions = _getTransactions(widget.farmerID, _selectedDateRange);
    });
  }

  Future<Map<String, dynamic>> _getTransactions(int farmerID, DateTimeRange? dateRange) async {
    List<Map<String, dynamic>> incomes = await IncomeDAO.instance.queryAllIncomes(farmerID);
    List<Map<String, dynamic>> expenses = await ExpenseDAO.instance.queryAllExpenses(farmerID);

    if (dateRange != null) {
      incomes = incomes.where((income) {
        DateTime incomeDate = DateTime.parse(income['date']);
        return incomeDate.isAfter(dateRange.start) && incomeDate.isBefore(dateRange.end);
      }).toList();

      expenses = expenses.where((expense) {
        DateTime expenseDate = DateTime.parse(expense['date']);
        return expenseDate.isAfter(dateRange.start) && expenseDate.isBefore(dateRange.end);
      }).toList();
    }

    return {'incomes': incomes, 'expenses': expenses};
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
      _fetchTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _selectDateRange(context),
            child: Text('Select Date Range'),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _transactions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No data available'));
                } else {
                  Map<String, dynamic> transactions = snapshot.data!;
                  List<Map<String, dynamic>> incomes = transactions['incomes'];
                  List<Map<String, dynamic>> expenses = transactions['expenses'];

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('Incomes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ...incomes.map((income) => ListTile(
                              title: Text('Amount: ${income['amount']}'),
                              subtitle: Text('Date: ${income['date']} ' ),
                            )),
                        SizedBox(height: 20),
                        Text('Expenses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ...expenses.map((expense) => ListTile(
                              title: Text('Amount: ${expense['amount']}'),
                              subtitle: Text('Date: ${expense['date']}'),
                            )),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
