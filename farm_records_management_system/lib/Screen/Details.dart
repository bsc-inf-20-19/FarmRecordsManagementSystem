
import 'package:flutter/material.dart';
import 'package:farm_records_management_system/Pages/databaseHelper.dart';

class Details extends StatefulWidget {
  final String livestockName;
  final String livestockDescription;
  final String livestockBreed;
  final String livestockType;

  const Details({
    Key? key,
    required this.livestockName,
    required this.livestockDescription,
    required this.livestockBreed,
    required this.livestockType,
  }) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livestock Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Livestock Name: ${widget.livestockName}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Livestock Description: ${widget.livestockDescription}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Livestock Breed: ${widget.livestockBreed}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Livestock Type: ${widget.livestockType}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
