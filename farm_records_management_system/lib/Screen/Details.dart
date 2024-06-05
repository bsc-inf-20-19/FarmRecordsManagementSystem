
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String livestockName;
  final String livestockDescription;
  final String livestockBreed;
  final String livestockType;

  const Details({
    super.key,
    required this.livestockName,
    required this.livestockDescription,
    required this.livestockBreed,
    required this.livestockType,
  });

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livestock Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Livestock Name: ${widget.livestockName}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Livestock Description: ${widget.livestockDescription}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Livestock Breed: ${widget.livestockBreed}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Livestock Type: ${widget.livestockType}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
