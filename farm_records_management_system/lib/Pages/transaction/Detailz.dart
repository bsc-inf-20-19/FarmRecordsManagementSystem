// import 'package:flutter/material.dart';

// class Details extends StatelessWidget{
//   Details({Key? key, required this.cropName, required this.cropDescription, 
//   required this.cropCompany, required this.cropType, required this.cropLotNumber,
//   required this.cropHarvest}) 
//   : super(key: key);

//   String cropName, cropDescription, cropCompany, cropType, cropLotNumber, cropHarvest;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Details"),
//         leading: IconButton(onPressed: (){
//           Navigator.pop(context);
//         }, icon: Icon(Icons.arrow_back)
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20.0),
//         child: ListView(
//           children: [
//             ListTile(
//               shape: RoundedRectangleBorder(
//                 side: BorderSide(width: 1.0, color: Colors.grey.shade300)
//               ),
//               leading: IconButton(
//                 icon: const Icon (Icons.bookmark_add_outlined,
//                 color: Colors.blueAccent),
//                 onPressed: () {},
//                 ),
//               title: Text(cropName,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold, fontSize: 18.0),
//               ),
//               subtitle: Text(cropDescription),
//               trailing: IconButton(
//                 icon: const Icon (Icons.edit,
//                 color: Colors.blueAccent),
//                 onPressed: () {},
//                 ),
                         
//               ),
//           ],
//         ),
//       )
//     );
//   }
// }