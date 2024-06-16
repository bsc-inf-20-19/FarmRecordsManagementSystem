import 'package:flutter/material.dart';

class CropListCard extends StatelessWidget {
  const CropListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.end, // position everything at the bottom
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child:   Icon(
                Icons.list, // icon representing a list
                size: 80.0,
                color: Colors.green,
          ),
            ),
          ),
        
          SizedBox(height: 10.0), // space between the icon and the text
          Text(
            "Crop Lists",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
