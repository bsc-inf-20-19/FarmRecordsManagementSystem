import 'package:flutter/material.dart';

class TransCard extends StatelessWidget {
  const TransCard({super.key});

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
        mainAxisAlignment: MainAxisAlignment.end, // position everything to the bottom
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Icon(
                Icons.attach_money, // Use a relevant icon
                size: 80.0, // Adjust the size as needed
                color: Colors.green, // Adjust the color as needed
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Transaction',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
