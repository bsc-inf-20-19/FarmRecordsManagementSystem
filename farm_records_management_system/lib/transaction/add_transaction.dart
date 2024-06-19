import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farm_records_management_system/transaction/expense_DAO.dart';
import 'package:farm_records_management_system/transaction/expense_model.dart';
import 'package:farm_records_management_system/transaction/income_DAO.dart';
import 'package:farm_records_management_system/transaction/income_model.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';

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
  String? _selectedCategory;
  String? _selectedPlanting;

  final List<String> _fieldSpecificities = ['Yes', 'No'];
  final List<String> _incomeTypes = ['Yes, specific to a planting', 'Other'];
  final List<String> _categories = ['Crop 1', 'Crop 2', 'Crop 3']; // Replace with actual categories
  List<Map<String, dynamic>> _plantings = [];

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

  Future<List<Map<String, dynamic>>> _fetchFields() async {
    try {
      return await DatabaseHelper.instance.getFields();
    } catch (e) {
      debugPrint('Error loading fields: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPlantings() async {
    try {
      return await DatabaseHelper.instance.getCrops();
    } catch (e) {
      debugPrint('Error loading plantings: $e');
      return [];
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
          if (_selectedField == null) {
            throw Exception('Field is required');
          }
          transactionData['field'] = _selectedField as Object;
          if (_selectedIncomeType == 'Yes, specific to a planting') {
            if (_selectedPlanting == null) {
              throw Exception('Planting is required');
            }
            transactionData['planting'] = _selectedPlanting as Object;
          } else {
            if (_selectedCategory == null) {
              throw Exception('Category is required');
            }
            transactionData['category'] = _selectedCategory as Object;
            if (_otherIncomeController.text.isEmpty) {
              throw Exception('Other income source is required');
            }
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

  Widget _buildTransactionForm() {
    return ListView(
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
              _selectedField = null;
              _selectedIncomeType = null;
              _selectedCategory = null;
              _selectedPlanting = null;
            });
          },
          validator: (value) => value == null ? 'Please select field specificity' : null,
        ),
        const SizedBox(height: 20),
        if (_selectedFieldSpecificity == 'Yes')
          Column(
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchFields(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Error loading fields');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No fields available');
                  } else {
                    final fields = snapshot.data!;
                    return DropdownButtonFormField<String>(
                      value: _selectedField,
                      decoration: const InputDecoration(
                        labelText: 'Select Field',
                        border: OutlineInputBorder(),
                      ),
                      items: fields.map((field) {
                        return DropdownMenuItem<String>(
                          value: field['fieldName'],
                          child: Text(field['fieldName']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedField = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a field' : null,
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedIncomeType,
                decoration: InputDecoration(
                  labelText: widget.isIncome
                      ? 'Is the income specific to a planting?'
                      : 'Is the expense specific to a planting?',
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
                    _selectedPlanting = null;
                    _selectedCategory = null;
                    if (newValue == 'Yes, specific to a planting') {
                      _fetchPlantings();
                    }
                  });
                },
                validator: (value) => value == null ? 'Select an income type' : null,
              ),
              const SizedBox(height: 20),
              if (_selectedIncomeType == 'Yes, specific to a planting')
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchPlantings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Text('Error loading plantings');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No plantings available');
                    } else {
                      final plantings = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        value: _selectedPlanting,
                        decoration: const InputDecoration(
                          labelText: 'Select Planting',
                          border: OutlineInputBorder(),
                        ),
                        items: plantings.map((planting) {
                          return DropdownMenuItem<String>(
                            value: planting['plantingID'].toString(),
                            child: Text(planting['name']),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPlanting = newValue;
                          });
                        },
                        validator: (value) => value == null ? 'Select a planting' : null,
                      );
                    }
                  },
                ),
              const SizedBox(height: 20),
              if (_selectedIncomeType == 'Other')
                Column(
                  children: [
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
                      validator: (value) => value == null ? 'Select a category' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _otherIncomeController,
                      decoration: const InputDecoration(
                        labelText: 'Other Income Source',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter other income source' : null,
                    ),
                  ],
                ),
            ],
          ),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
        ),
        const SizedBox(height: 20),
      ElevatedButton(
  onPressed: _submitForm,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange, // Set the background color to orange
  ),
  child: const Text('Add Transaction'),
),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.isIncome ? 'New Income' : 'New Expense', style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: _buildTransactionForm(),
        ),
      ),
    );
  }
}
