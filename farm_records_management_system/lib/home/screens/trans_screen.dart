import 'package:flutter/material.dart';


class TransactionListScreen extends StatefulWidget {
  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: Text('Transaction'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Expenses'),
            Tab(text: 'Income'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    // Handle filter button press
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  children: [
                    TransactionCard(title: 'Farm lease', date: 'April 1st, 2024', amount: 'MWK100,000'),
                    TransactionCard(title: 'Labor', date: 'April 1st, 2024', amount: 'MWK50,000'),
                    TransactionCard(title: 'Seeds (30 KG)', date: 'April 1st, 2024', amount: 'MWK50,000'),
                    TransactionCard(title: 'Fertilizer (100 Kg)', date: 'April 1st, 2024', amount: 'MWK140,000'),
                    TransactionCard(title: 'Pesticides', date: 'April 1st, 2024', amount: 'MWK70,000'),
                    TransactionCard(title: 'Farming Tools', date: 'April 1st, 2014', amount: 'MWK300,000'),
                  ],
                ),
                Center(
                  child: Text('Income transactions will be listed here'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add new transaction
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String title;
  final String date;
  final String amount;

  TransactionCard({required this.title, required this.date, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
