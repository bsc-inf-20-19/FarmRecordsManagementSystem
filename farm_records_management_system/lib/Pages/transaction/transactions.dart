import 'package:farm_records_management_system/Pages/transaction/Expense.dart';
import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  const Transaction({Key? key});

  @override
  Widget build(BuildContext context) {
    return Trans(
      expenseName: '',
      amount: 0.0,
      description: '',
    );
  }
}

class Trans extends StatelessWidget {
  Trans({
    Key? key,
    required this.expenseName,
    required this.amount,
    required this.description,
  }) : super(key: key);

  final String expenseName;
  final String description;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Transactions'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(
                      side:
                          BorderSide(width: 1.0, color: Colors.grey.shade300)),
                  leading: IconButton(
                    icon: const Icon(
                      Icons.bookmark_add_outlined,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {},
                  ),
                  title: Text(
                    expenseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  subtitle: Text(description),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {},
                  ),
                ),
                // Add more ListTiles as needed
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Expense()));
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
