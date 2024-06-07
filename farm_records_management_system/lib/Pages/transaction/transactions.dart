import 'package:farm_records_management_system/Pages/transaction/Expense.dart';
import 'package:farm_records_management_system/screens/databaseHelper.dart';
import 'package:farm_records_management_system/screens/updateTransactionPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Map<String, dynamic>> transactions = []; // Store transaction data
  late TextEditingController searchController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData(); // Load initial data
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> result = await DatabaseHelper.getTransactions();
      setState(() {
        transactions = result.reversed.toList(); // Ensure data is stored in the state
      });
    } catch (e) {
      debugPrint('Error loading transactions: $e'); // Handle exceptions
    }
  }

  void _applySearchFilter(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        isSearching = false;
        _loadData();
      } else {
        isSearching = true;
        transactions = transactions.where((transaction) {
          // Filter by name, type, or date
          return transaction['description'].toLowerCase().contains(searchTerm) ||
              transaction['expense_type'].toLowerCase().contains(searchTerm) ||
              transaction['customer_name'].toLowerCase().contains(searchTerm) ||
              transaction['field'].toLowerCase().contains(searchTerm) ||
              transaction['date'].toLowerCase().contains(searchTerm);
        }).toList();
      }
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 'Invalid Date'; // Fallback for null or empty date strings
    }

    try {
      final date = DateTime.parse(dateStr); // Attempt to parse the date
      return DateFormat("yyyy-MM-dd").format(date); // Format the date
    } catch (e) {
      debugPrint('Invalid date format: $e'); // Handle parsing exceptions
      return 'Invalid Date'; // Fallback for invalid format
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                onChanged: _applySearchFilter,
                decoration: const InputDecoration(
                  hintText: 'Search by name, type, or date',
                  border: InputBorder.none,
                ),
              )
            : const Text('Transactions'), // Transactions title
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear(); // Clear search field when closing
                }
                isSearching = !isSearching; // Toggle search state
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          var transaction = transactions[index];
          String formattedDate = _formatDate(transaction["date"]); // Format the date
          return ListTile(
            title: Text(
              formattedDate,
            ),
            subtitle: Text(
              'Type: ${transaction["expense_type"]}, Description: ${transaction["description"]}, Field: ${transaction["field"]}, Amount: ${transaction["amount"] ?? 0}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateExpensePage(
                          transactionId: transaction['id'],
                        ),
                      ),
                    ).then((result) {
                      if (result == true) {
                        _loadData(); // Refresh after update
                      }
                    });
                  },
                  icon: const Icon(Icons.edit, color: Colors.green),
                ),
                IconButton(
                  onPressed: () async {
                    await DatabaseHelper.deleteTransaction(transaction['id']);
                    _loadData(); // Refresh after deletion
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final addedTransaction = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpensePage(
                onAdd: _addTransaction,
                existingExpense: const ['Maize', 'GroundNuts'],
                onNewExpenseRequested: () {
                  // Logic for new fields
                },
              ),
            ),
          );
          if (addedTransaction != null) {
            _loadData(); // Refresh after successful addition
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTransaction(Map<String, dynamic> newTransaction) async {
    // Access text values from TextEditingController objects
    String customerName = newTransaction['customer_name'];
    String selectedTransactionType = newTransaction['expense_type'];
    String selectedField = newTransaction['field'];
    String description = newTransaction['description'];
    double amount = newTransaction['amount'];

    try {
      // Check for null values and validate them
      if (newTransaction['date'] == null) {
        throw Exception('Date is required'); // Custom error message
      }

      // Build the new transaction map with appropriate values
      Map<String, dynamic> newExpense = {
        'date': newTransaction['date'],
        'customer_name': customerName,
        'expense_type': selectedTransactionType,
        'field': selectedField,
        'description': description,
        'amount': amount,
      };

      DatabaseHelper.insertTransaction(newExpense);
      // Navigate back to the previous screen
      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Error adding transaction: $e'); // Improved error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding transaction: $e')), // Display error message
      );
    }
  }
}
