import 'package:flutter/material.dart';

class Details extends StatelessWidget{
  Details({Key? key, required this.cropList,
  required this.fieldList, required this.cropDescription, 
  required this.cropCompany, required this.cropType, 
  required this.cropLotNumber, required this.cropHarvest}) 
  : super(key: key);

  String cropList, fieldList, cropDescription, cropCompany, 
  cropType, cropLotNumber, cropHarvest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Details'),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.more_vert),
                    ),
                  Text(
                    cropList,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    thickness: .5,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            //Row for crop details.
            Row(
              children: [
                Text(
                  'Crop Name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18,
                  ),
                ),
                Expanded(
                  child: Align(

                    alignment: Alignment.centerRight,
                    child: Padding(padding: 
                    EdgeInsets.only(right: 50, bottom: 10,),
                    child: Text(
                      cropList,
                      style: TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 18,
                      ),
                    ),),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Text(
                  'Field Name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18,
                  ),
                ),
                Expanded(
                  child: Align(

                    alignment: Alignment.centerRight,
                    child: Padding(padding: 
                    EdgeInsets.only(right: 50, bottom: 10,),
                    child: Text(
                      fieldList,
                      style: TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 18,
                      ),
                    ),),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Text(
                  'Seed Quantity:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18,
                  ),
                ),
                Expanded(
                  child: Align(

                    alignment: Alignment.centerRight,
                    child: Padding(padding: 
                    EdgeInsets.only(right: 50, bottom: 10,),
                    child: Text(
                      cropDescription,
                      style: TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 18,
                      ),
                    ),),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Text(
                  'Crop Company:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18,
                  ),
                ),
                Expanded(
                  child: Align(

                    alignment: Alignment.centerRight,
                    child: Padding(padding: 
                    EdgeInsets.only(right: 50, bottom: 10,),
                    child: Text(
                      cropCompany,
                      style: TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 18,
                      ),
                    ),),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Text(
                  'Crop Type:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18,
                  ),
                ),
                Expanded(
                  child: Align(

                    alignment: Alignment.centerRight,
                    child: Padding(padding: 
                    EdgeInsets.only(right: 50, bottom: 10,),
                    child: Text(
                      cropType,
                      style: TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 18,
                      ),
                    ),),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Text(
                  'Lot Number:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18,
                  ),
                ),
                Expanded(
                  child: Align(

                    alignment: Alignment.centerRight,
                    child: Padding(padding: 
                    EdgeInsets.only(right: 50, bottom: 10,),
                    child: Text(
                      cropLotNumber,
                      style: TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 18,
                      ),
                    ),),
                  ),
                ),
              ],
            ),

            Row(
                children: [
                  Text(
                    'Estimated Harvest:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18,
                    ),
                  ),
                  Expanded(
                    child: Align(

                      alignment: Alignment.centerRight,
                      child: Padding(padding: 
                      EdgeInsets.only(right: 50, bottom: 10,),
                      child: Text(
                        cropHarvest,
                        style: TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 18,
                        ),
                      ),),
                    ),
                  ),
                ],
              ),
                        
          ],
        ),
      ),
    ),
    );
  }
}