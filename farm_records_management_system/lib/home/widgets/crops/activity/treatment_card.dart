import 'package:flutter/material.dart';

class TreatmentCard extends StatelessWidget {
  const TreatmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width / 2 -
            32, // minus 32 due to the margin
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
          mainAxisAlignment: MainAxisAlignment
              .end, // posion the everything to the bottom
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Insert image here
            Image(
              image: AssetImage('images/fertilizer.png'), // URL of the image
              width: 100.0, // Set the width of the image
              height: 100.0, // Set the height of the image
              fit: BoxFit.cover, 
            ),
            Text("Treatment",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
