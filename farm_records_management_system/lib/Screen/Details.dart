import 'package:flutter/material.dart';

class Details extends StatelessWidget{
  Details({Key? key, required this.livestockName, required this.livestockDescription, 
  required this.livestockBreed, required this.livestockType}) 
  : super(key: key);

  String livestockName, livestockDescription, livestockBreed, livestockType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, color: Colors.grey.shade300)
              ),
              leading: IconButton(
                icon: const Icon (Icons.bookmark_add_outlined,
                color: Colors.blueAccent),
                onPressed: () {},
                ),
              title: Text(livestockDescription,
              style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              subtitle: Text(livestockBreed),
              trailing: IconButton(
                icon: const Icon (Icons.edit,
                color: Colors.blueAccent),
                onPressed: () {},
                ),
                
                
              ),
          ],
        ),
      )
    );
  }
}