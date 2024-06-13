import 'package:flutter/material.dart';

class FarmTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {
              // handle filter button press
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.tune),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.filter_alt_outlined),
                  SizedBox(width: 8.0),
                  Text(
                    'Date created',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView(
                  children: [
                    _buildTaskItem('Task Completed'),
                    _buildTaskItem('Pending'),
                    _buildTaskItem('Task Completed'),
                    _buildTaskItem('Task Completed'),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildTaskItem(String status) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: Icon(Icons.note, size: 50, color: Colors.green),
        title: Text('Lorem Ipsum'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lorem ipsum dolor sit amet,'),
            SizedBox(height: 8.0),
            Text(
              status,
              style: TextStyle(
                color: status == 'Task Completed' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

