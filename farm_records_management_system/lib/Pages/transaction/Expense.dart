import 'package:farm_records_management_system/Pages/transaction/transactions.dart';
import 'package:farm_records_management_system/Pages/transaction/transactions.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';
// import 'package:farm_records_management_system/Services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  final List<String> existingExpense;
  final VoidCallback onNewExpenseRequested;

   const ExpensePage({
    super.key,
    required this.onAdd,
    required this.existingExpense,
    required this.onNewExpenseRequested,
  });

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customerNameController = TextEditingController();
  // String? _customerNameController;
  String? _selectedTransactionType;
  String? _selectedField;
  DateTime? _selectedDate;
  // String? _chooseCategory;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _customerNameController.dispose();
    super.dispose(); // Proper resource cleanup
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  //  String _getStatusFromDate(DateTime date) {
  //   return date.isAfter(DateTime.now()) ? 'Planned' : 'Done';
  // }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Invalid Date';
    }
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate) // Format the date
                        : 'Select Date', // Prompt to select a date
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              // Dropdown for Treatment Type
              DropdownButtonFormField<String>(
                value: _selectedTransactionType,
                items: [
                  'Choose category',
                  'Other',
                ].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'expense Type',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedTransactionType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a expense type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              if (_selectedTransactionType == 'Other') ...[
                TextFormField(
                  controller: TextEditingController(),// changes here
                  decoration: const InputDecoration(
                    labelText: 'Specify expense Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a expense type';
                    }
                    return null;
                  },
                ),
              ],
              // Dropdown for Field
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedField,
                      items: widget.existingExpense.map((field) {
                        return DropdownMenuItem(
                          value: field,
                          child: Text(field),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Field',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedField = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a field';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onNewExpenseRequested,
                    icon: const Icon(Icons.add),
                    tooltip: 'Add New Field',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Product Used TextField
              TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,  // Set keyboard type to number
              decoration: const InputDecoration(
                labelText: 'How much did you spend?',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the amount spent';
                }
                return null;
              },
            ),
              const SizedBox(height: 20),

               TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'customer name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the customer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Quantity TextField
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Write notes...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the notes';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Add Treatment Button
              ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()){
      try {
        // Check for null values and validate them
        if (_selectedDate == null) {
          throw Exception('Date is required'); // Custom error message
        }
        
        // Build the new treatment map
        Map<String, dynamic> newExpense = {
          'date': DateFormat("yyyy-MM-dd").format(_selectedDate!), // Ensure non-null date
          'customer_name': _customerNameController.text, // Ensure it's not null
          'expense_type': _selectedTransactionType, // Ensure it's not null
          'field': _selectedField, // Ensure it's not null
          'description': _descriptionController.text, // Ensure it's not empty
          'amount': double.tryParse(_amountController.text) ?? 0.0, // Avoid null
        };
         DatabaseHelper.insertTransaction(newExpense);
        // Navigate back to the previous screen
        Navigator.pop(context, true);

      } catch (e) {
        debugPrint('Error adding treatment: $e'); // Improved error handling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding treatment: $e')), // Display error message
        );
      }
    }
  },
                child: const Text('Add Treatment'),
              ),
            ],
          )
        ),
      ),
    );
  }
}
