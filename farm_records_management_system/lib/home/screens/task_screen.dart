import 'package:farm_records_management_system/home/widgets/fieldbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Change icon color to white
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Change title text color to white
        leading: IconButton(
           onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Back',
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Tasks'),
        centerTitle: true,
        actions:[
          IconButton(
            onPressed: () {}, 
            tooltip: 'Search',
          icon: Icon(Icons.search),
          )
        ],
      ),
      body: ListView(
        children: [
          //Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search task',
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
          
          //Latest Items
        ],
      ),
    );
  }
}

