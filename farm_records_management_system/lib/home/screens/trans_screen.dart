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
          indicatorColor: Colors.green, // Change the indicator color here
          indicatorWeight: 4.0, // Change the indicator thickness if needed
          labelColor: Colors.green, // Active tab text color
          unselectedLabelColor: Colors.grey, // Inactive tab text color
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
                    TransactionCard(
                      title: 'Farm lease', 
                      description: 'Leasing the farm for this season.', 
                      date: 'April 1st, 2024', 
                      amount: 'MWK100,000'
                    ),
                    TransactionCard(
                      title: 'Fertilizer (100 Kg)', 
                      description: 'Purchased 100 Kg of fertilizer.', 
                      date: 'April 1st, 2024', 
                      amount: 'MWK140,000'
                    ),
                    TransactionCard(
                      title: 'Pesticides', 
                      description: 'Bought pesticides for crop protection.', 
                      date: 'April 1st, 2024', 
                      amount: 'MWK70,000'
                    ),
                    TransactionCard(
                      title: 'Equipment rent', 
                      description: 'Rent equipment for farm.', 
                      date: 'April 1st, 2014', 
                      amount: 'MWK30,000'
                    ),
                  ],
                ),
                ListView(
                  children: [
                    TransactionCard(
                      title: 'Harvest sales', 
                      description: 'Revenue from the sale of the harvest.', 
                      date: 'April 1st, 2024', 
                      amount: 'MWK5,000,000'
                    ),
                    TransactionCard(
                      title: 'Products sales', 
                      description: 'Income from selling products.', 
                      date: 'April 1st, 2024', 
                      amount: 'MWK6,500,000'
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Handle add new transaction
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Add Transaction', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String amount;

  TransactionCard({
    required this.title,
    required this.description,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(description),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  amount,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
