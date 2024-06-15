import 'package:farm_records_management_system/transaction/add_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'expense_DAO.dart';
import 'income_DAO.dart';

class ManageTransactionsScreen extends StatefulWidget {
  final int farmerID;

  ManageTransactionsScreen({required this.farmerID});

  @override
  _ManageTransactionsScreenState createState() => _ManageTransactionsScreenState();
}

class _ManageTransactionsScreenState extends State<ManageTransactionsScreen> {
  List<Map<String, dynamic>> _incomeTransactions = [];
  List<Map<String, dynamic>> _expenseTransactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final incomes = await IncomeDAO.instance.queryAllIncomes(widget.farmerID);
    final expenses = await ExpenseDAO.instance.queryAllExpenses(widget.farmerID);
    setState(() {
      _incomeTransactions = incomes;
      _expenseTransactions = expenses;
    });
  }

  void _navigateToAddTransactionScreen(bool isIncome) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(
          isIncome: isIncome,
          farmerID: widget.farmerID,
          refreshTransactions: _fetchTransactions,
        ),
      ),
    );
    _fetchTransactions(); // Refresh transactions after returning from AddTransactionScreen
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Transactions'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Income'),
              Tab(text: 'Expense'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTransactionList(_incomeTransactions, 'Income'),
            _buildTransactionList(_expenseTransactions, 'Expense'),
          ],
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     final isIncome = DefaultTabController.of(context)!.index == 0;
        //     _navigateToAddTransactionScreen(isIncome);
        //   },
        //   icon: Icon(Icons.add),
        //   label: Text('Add Transaction'),
        // ),
      ),
    );
  }

  Widget _buildTransactionList(List<Map<String, dynamic>> transactions, String type) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text(transaction['description']),
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction['date']))),
                  trailing: Text('\$${transaction['amount']}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final isIncome = type == 'Income';
              _navigateToAddTransactionScreen(isIncome);
            },
            child: Text('Add $type Transaction'),
          ),
        ],
      ),
    );
  }
}
