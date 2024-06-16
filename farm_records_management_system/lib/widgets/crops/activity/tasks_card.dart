import 'package:farm_records_management_system/Pages/taskListPage.dart';
import 'package:flutter/material.dart';

class TasksCard extends StatelessWidget {
  const TasksCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskListScreen(),
          ),
        );
      },
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width / 2 - 32,
        margin: const EdgeInsets.all(14.0),
        padding: const EdgeInsets.all(14.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 0.5,
              offset: Offset(2.0, 2.0),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
            child: Center(
              child: Icon(
                Icons.task, // Use a relevant icon
                size: 80.0, // Adjust the size as needed
                color: Colors.green, // Adjust the color as needed
              ),
            ),
          ),
          SizedBox(height: 10),
            Text(
              "Tasks",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
