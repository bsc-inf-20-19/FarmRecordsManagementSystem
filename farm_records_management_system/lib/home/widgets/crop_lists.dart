import 'package:flutter/material.dart';

class CropListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: 5,
        itemBuilder: (context, index) {
          return CroplistCard();
        },
      ),
         );
  }
}

class CroplistCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.autorenew),
        title: Text(
          'Maize',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              'Kanyani',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios), //color: Colors.white),
      ),
    );
  }
}
