import 'package:flutter/material.dart';

class EquipmentCard extends StatelessWidget {
  const EquipmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(14.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5.0,
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width / 2 - 32, // minus 32 due to the margin
        padding: const EdgeInsets.all(14.0),
        decoration: const BoxDecoration(
          color: Colors.white, // background color of the card
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end, // position everything to the bottom
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Insert image here
            Image(
              image: AssetImage('images/report.png'), // URL of the image
              width: 100.0, // Set the width of the image
              height: 100.0, // Set the height of the image
              fit: BoxFit.cover,
            ),
            Text(
              "Equipment",
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
