import 'package:farm_records_management_system/transaction/expense_DAO.dart';
import 'package:farm_records_management_system/transaction/expense_model.dart';
import 'package:farm_records_management_system/transaction/income_DAO.dart';
import 'package:farm_records_management_system/transaction/income_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageTransactionsScreen extends StatefulWidget {
  final int farmerID;

  ManageTransactionsScreen({required this.farmerID});

  @override
  _ManageTransactionsScreenState createState() =>
      _ManageTransactionsScreenState();
}

class _ManageTransactionsScreenState extends State<ManageTransactionsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = true;
  double _amount = 0;
  String _description = '';
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  bool _isFieldSpecific = false;
  String _category = 'Harvest';
  String _otherCategory = '';
  String _selectedField = '';
  String _selectedPlanting = '';
  List<String> _fields = ['Field 1', 'Field 2', 'Field 3']; // Replace with actual fields
  List<String> _plantings = ['Planting 1', 'Planting 2', 'Planting 3']; // Replace with actual plantings
  List<Map<String, dynamic>> _incomeTransactions = [];
  List<Map<String, dynamic>> _expenseTransactions = [];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    _fetchTransactions();
  }

  void _fetchTransactions() async {
    final incomes = await IncomeDAO.instance.queryAllIncomes(widget.farmerID);
    final expenses = await ExpenseDAO.instance.queryAllExpenses(widget.farmerID);
    setState(() {
      _incomeTransactions = incomes;
      _expenseTransactions = expenses;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> transactionData = {
        'amount': _amount,
        'date': _selectedDate.toIso8601String(),
        'description': _description,
        'farmersID': widget.farmerID,
      };

      if (_isIncome) {
        Transaction income = Transaction(
          amount: _amount,
          date: _selectedDate,
          description: _description,
          farmersID: widget.farmerID,
        );
        await IncomeDAO.instance.insertIncome(income.toMap());
      } else {
        Expense expense = Expense(
          amount: _amount,
          date: _selectedDate,
          description: _description,
          farmersID: widget.farmerID,
        );
        await ExpenseDAO.instance.insertExpense(expense.toMap());
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Transaction added')));
      _fetchTransactions();
      Navigator.of(context).pop();
    }
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Transaction'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                SwitchListTile(
                title: Text(_isIncome ? 'Income' : 'Expense'),
                value: _isIncome,
                onChanged: (bool value) {
                  setState(() {
                    _isIncome = value;
                  });
                },
              ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _amount = double.parse(value!);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      ).then((date) {
                        setState(() {
                          if (date != null) {
                            _selectedDate = date;
                            _dateController.text =
                                DateFormat('yyyy-MM-dd').format(_selectedDate);
                          }
                        });
                      });
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(labelText: 'Date'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('Is this transaction specific to a field?'),
                    value: _isFieldSpecific,
                    onChanged: (bool? value) {
                      setState(() {
                        _isFieldSpecific = value ?? false;
                      });
                    },
                  ),
                  if (_isFieldSpecific)
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Select Field'),
                      value: _selectedField.isNotEmpty ? _selectedField : null,
                      items: _fields.map((field) {
                        return DropdownMenuItem<String>(
                          value: field,
                          child: Text(field),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedField = newValue!;
                        });
                      },
                    ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Category'),
                    value: _category,
                    items: ['Harvest', 'Other'].map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue!;
                      });
                    },
                  ),
                  if (_category == 'Other')
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Specify Other Category'),
                      onSaved: (value) {
                        _otherCategory = value!;
                      },
                    ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Select Planting'),
                    value: _selectedPlanting.isNotEmpty ? _selectedPlanting : null,
                    items: _plantings.map((planting) {
                      return DropdownMenuItem<String>(
                        value: planting,
                        child: Text(planting),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPlanting = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Add Transaction'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
         floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddTransactionDialog,
          icon: Icon(Icons.add),
          label: Text('Add Transaction'),
        ),
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
        ],
      ),
    );
  }
}
