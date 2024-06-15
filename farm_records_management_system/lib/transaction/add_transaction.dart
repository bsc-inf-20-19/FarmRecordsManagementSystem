import 'package:farm_records_management_system/transaction/expense_DAO.dart';
import 'package:farm_records_management_system/transaction/expense_model.dart';
import 'package:farm_records_management_system/transaction/income_DAO.dart';
import 'package:farm_records_management_system/transaction/income_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isIncome;
  final int farmerID;
  final Function() refreshTransactions;

  const AddTransactionScreen({
    Key? key,
    required this.isIncome,
    required this.farmerID,
    required this.refreshTransactions,
  }) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _otherIncomeController = TextEditingController();
  DateTime? _selectedDate;

  String? _selectedFieldSpecificity;
  String? _selectedIncomeType;
  String? _selectedField;
  String? _selectedPlanting;
  String? _selectedCategory;

  final List<String> _fieldSpecificities = ['Yes', 'No'];
  final List<String> _incomeTypes = ['Category', 'Other'];
  final List<String> _fields = ['Field 1', 'Field 2', 'Field 3']; // Replace with actual fields
  final List<String> _plantings = ['Planting 1', 'Planting 2', 'Planting 3']; // Replace with actual plantings
  final List<String> _categories = ['Crop 1', 'Crop 2', 'Crop 3']; // Replace with actual categories

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (_selectedDate == null) {
          throw Exception('Date is required');
        }

        final transactionData = {
          'amount': double.parse(_amountController.text),
          'date': _selectedDate!.toIso8601String(),
          'description': _descriptionController.text,
          'farmersID': widget.farmerID,
        };

        if (_selectedFieldSpecificity == 'Yes') {
          transactionData['field'] = _selectedField as Object;
          if (_selectedIncomeType == 'Category') {
            transactionData['category'] = _selectedCategory as Object;
          } else {
            transactionData['otherIncomeSource'] = _otherIncomeController.text;
          }
        }

        if (widget.isIncome) {
          final income = Transaction.fromMap(transactionData);
          await IncomeDAO.instance.insertIncome(income.toMap());
        } else {
          final expense = Expense.fromMap(transactionData);
          await ExpenseDAO.instance.insertExpense(expense.toMap());
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaction added')));
        widget.refreshTransactions();
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding transaction: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.isIncome ? 'Income' : 'Expense'} Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                  child: Text(
                    _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Select Date',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedFieldSpecificity,
                decoration: const InputDecoration(
                  labelText: 'Is this transaction specific to a field?',
                  border: OutlineInputBorder(),
                ),
                items: _fieldSpecificities.map((String specificity) {
                  return DropdownMenuItem<String>(
                    value: specificity,
                    child: Text(specificity),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFieldSpecificity = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select field specificity' : null,
              ),
              if (_selectedFieldSpecificity == 'Yes') ...[
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedField,
                  decoration: const InputDecoration(
                    labelText: 'Select Field',
                    border: OutlineInputBorder(),
                  ),
                  items: _fields.map((String field) {
                    return DropdownMenuItem<String>(
                      value: field,
                      child: Text(field),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedField = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a field' : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedIncomeType,
                  decoration: const InputDecoration(
                    labelText: 'Is the income specific to a planting?',
                    border: OutlineInputBorder(),
                  ),
                  items: _incomeTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedIncomeType = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Sewlect an income type' : null,
                ),
                if (_selectedIncomeType == 'Category') ...[
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a category' : null,
                  ),
                ] else if (_selectedIncomeType == 'Other') ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _otherIncomeController,
                    decoration: const InputDecoration(
                      labelText: 'Specify Income Source',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please specify the income source';
                      }
                      return null;
                    },
                  ),
                ],
              ],
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Name of customer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
