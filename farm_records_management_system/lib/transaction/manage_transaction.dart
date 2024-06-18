import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farm_records_management_system/transaction/add_transaction.dart';
import 'package:farm_records_management_system/transaction/expense_DAO.dart';
import 'package:farm_records_management_system/transaction/income_DAO.dart';

class ManageTransactionsScreen extends StatefulWidget {
  final int farmerID;

  const ManageTransactionsScreen({Key? key, required this.farmerID}) : super(key: key);

  @override
  _ManageTransactionsScreenState createState() => _ManageTransactionsScreenState();
}

class _ManageTransactionsScreenState extends State<ManageTransactionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _incomeTransactions = [];
  List<Map<String, dynamic>> _expenseTransactions = [];
  final int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  Widget _buildTransactionList(List<Map<String, dynamic>> transactions, String type) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No $type to display',
          style: const TextStyle(color: Colors.orange), // Set message text color to orange
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            color: const Color(0xFFC7C7C7),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTransactionDetail('Description', transaction['description']),
                  _buildTransactionDetail('Date', DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction['date']))),
                  _buildTransactionDetail('Amount', '\$${transaction['amount']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Transactions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), // Adjust the height as needed
          child: Container(
            color: Colors.white, // Set the background color for the tab bar section
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white, // Active tab text color
              unselectedLabelColor: Colors.black, // Inactive tab text color
              indicator: BoxDecoration(
                color: Colors.orange, // Active tab color
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  icon: _selectedTabIndex == 0 ? const Icon(Icons.attach_money, color: Colors.white) : null,
                  text: 'INCOME',
                ),
                Tab(
                  icon: _selectedTabIndex == 0 ? const Icon(Icons.attach_money, color: Colors.white) : null,
                  text: 'EXPENSES',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionList(_incomeTransactions, 'Income'),
          _buildTransactionList(_expenseTransactions, 'Expense'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final isIncome = _tabController.index == 0;
          _navigateToAddTransactionScreen(isIncome);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange, // Set button color to orange
      ),
    );
  }
}
