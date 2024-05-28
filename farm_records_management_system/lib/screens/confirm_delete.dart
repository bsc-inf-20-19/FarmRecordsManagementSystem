// import 'package:farm_records_management_system/Pages/databaseHelper.dart';
// import 'package:flutter/material.dart';

// class DeleteTransPage extends StatefulWidget {
//   const DeleteTransPage({Key? key}) : super(key: key);

//   @override
//   _DeleteTransPageState createState() => _DeleteTransPageState();
// }

// class _DeleteTransPageState extends State<DeleteTransPage> {
//   // Your existing code...

//   Future<void> _confirmDelete(int transactionId) async {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Confirm Delete"),
//           content: const Text("Are you sure you want to delete this transaction?"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await DatabaseHelper.deleteTransaction(transactionId);
//                // _loadData(); // Refresh after deletion
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text(
//                 "Delete",
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Your existing Scaffold code...
//       body: ListView.builder(
//         itemCount: transactions.length,
//         itemBuilder: (context, index) {
//           var transaction = transactions[index];
//           // Your existing ListTile code...
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => UpdateExpensePage(
//                         transactionId: transaction['id'],
//                       ),
//                     ),
//                   ).then((result) {
//                     if (result == true) {
//                       _loadData(); // Refresh after update
//                     }
//                   });
//                 },
//                 icon: const Icon(Icons.edit, color: Colors.green),
//               ),
//               IconButton(
//                 onPressed: () {
//                   _confirmDelete(transaction['id']);
//                 },
//                 icon: const Icon(Icons.delete, color: Colors.red),
//               ),
//             ],
//           ),
//         },
//       ),
//       // Your existing FloatingActionButton code...
//     );
//   }
// }
