import 'package:flutter/material.dart';

class FieldsCard extends StatelessWidget {
  const FieldsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Ensure the container has a finite height
      width: MediaQuery.of(context).size.width / 2 - 32, // minus 32 due to the margin
      margin: const EdgeInsets.all(14.0),
      padding: const EdgeInsets.all(14.0),
      decoration: const BoxDecoration(
        color: Colors.white, // background color of the cards
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: [
          // this is the shadow of the card
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0.5,
            offset: Offset(2.0, 2.0),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // position everything to the bottom
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // place here your icon
          const Expanded(
            child: Center(
              child: Icon(
                Icons.terrain, // Use a relevant icon
                size: 80.0, // Adjust the size as needed
                color: Colors.green, // Adjust the color as needed
              ),
            ),
          ),
          const SizedBox(height: 8.0), // Add some spacing between the icon and text
          const Text("Fields",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}