import 'package:flutter/material.dart';

class HomeScreenCard extends StatefulWidget {
  @override
  _HomeScreenCard createState() => _HomeScreenCard();
}

class _HomeScreenCard extends State<HomeScreenCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white, // background color
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16.0, top: 20.0),
              child: Text("All rooms", style: TextStyle(color: Colors.blue[900], fontSize: 24.0, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 200,
              child: Row(
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width / 2 - 32, // minus 32 due to the margin
                    margin: EdgeInsets.all(14.0),
                    padding: EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
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
                      mainAxisAlignment: MainAxisAlignment.end, // posion the everything to the bottom
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // place here your image
                        Text("Crops", style: TextStyle(fontSize: 20.0, color: Colors.brown, fontWeight: FontWeight.bold)),
                        
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width / 2 - 32, // minus 32 due to the margin
                    margin: EdgeInsets.all(14.0),
                    padding: EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
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
                      mainAxisAlignment: MainAxisAlignment.end, // posion the everything to the bottom
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // place here your image
                        Text("Livestocks", style: TextStyle(fontSize: 20.0, color: Colors.brown, fontWeight: FontWeight.bold)),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Container(
              height: 200,
              child: Row(
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width / 2 - 32, // minus 32 due to the margin
                    margin: EdgeInsets.all(14.0),
                    padding: EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
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
                      mainAxisAlignment: MainAxisAlignment.end, // posion the everything to the bottom
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // place here your image
                        Text("Report", style: TextStyle(fontSize: 20.0, color: Colors.brown, fontWeight: FontWeight.bold)),
                        
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width / 2 - 32, // minus 32 due to the margin
                    margin: EdgeInsets.all(14.0),
                    padding: EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
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
                      mainAxisAlignment: MainAxisAlignment.end, // posion the everything to the bottom
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // place here your image
                        Text("Farm Setup", style: TextStyle(fontSize: 20.0, color: Colors.brown, fontWeight: FontWeight.bold)),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}