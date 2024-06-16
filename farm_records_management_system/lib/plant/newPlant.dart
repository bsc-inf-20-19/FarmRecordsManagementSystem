// import 'package:flutter/material.dart';
// import 'package:farm_records_management_system/database/databaseHelper.dart';

// class PlantingRecordsPage extends StatefulWidget {
//   const PlantingRecordsPage({Key? key}) : super(key: key);

//   @override
//   _PlantingRecordsPageState createState() => _PlantingRecordsPageState();
// }

// class _PlantingRecordsPageState extends State<PlantingRecordsPage> {
//   List<Map<String, dynamic>> _plantings = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchPlantings();
//   }

//   Future<void> _fetchPlantings() async {
//     final plantings = await DatabaseHelper.instance.getPlantings();
//     setState(() {
//       _plantings = plantings;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Planting Records'),
//         backgroundColor: Colors.green,
//       ),
//       body: _plantings.isEmpty
//           ? const Center(child: Text('No records found'))
//           : ListView.builder(
//               itemCount: _plantings.length,
//               itemBuilder: (context, index) {
//                 final planting = _plantings[index];
//                 return ListTile(
//                   title: Text('Crop: ${planting['crop']}'),
//                   subtitle: Text('Field: ${planting['field']}\nDate: ${planting['date']}'),
//                   trailing: const Icon(Icons.arrow_forward),
//                   onTap: () {
//                     // Navigate to detail page if needed
//                   },
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const NewPlantPage()),
//           );

//           if (result == true) {
//             _fetchPlantings(); // Refresh the records after adding a new planting
//           }
//         },
//         backgroundColor: Colors.green,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
