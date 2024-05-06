// import 'package:farm_records_management_system/Pages/databaseHelper.dart';
// import 'package:farm_records_management_system/Pages/updateUser.dart';
// import 'package:flutter/material.dart';

// class CropPage extends StatefulWidget {
//   const CropPage({Key? key}) : super(key: key);

//   @override
//   _CropPageState createState() => _CropPageState();
// }

// class _CropPageState extends State<CropPage> {
//   final _nameController = TextEditingController();
//   final _ageController = TextEditingController();
//   List<Map<String, dynamic>> dataList = [];

//   void _saveData() async {
//     final name = _nameController.text;
//     final age = int.tryParse(_ageController.text) ?? 0;
//     int insertId = await DatabaseHelper.insertUser(name, age);
//     print(insertId);

//     List<Map<String, dynamic>> updatedData = await DatabaseHelper.getData();
//     setState(() {
//       dataList = updatedData;
//     });

//     _nameController.text = '';
//     _ageController.text = '';
//   }

//   void initState() {
//     _fetchUsers();
//     super.initState();
//   }

//   void _fetchUsers() async {
//     List<Map<String, dynamic>> userList = await DatabaseHelper.getData();
//     setState(() {
//       dataList = userList;
//     });
//   }

//   void _delete(int docId) async {
//     int id = await DatabaseHelper.deleteData(docId);
//     List<Map<String, dynamic>> updatedData = await DatabaseHelper.getData();
//     setState(() {
//       dataList = updatedData;
//     });
//   }

//   void fetchData() async {
//     List<Map<String, dynamic>> fetchedData = await DatabaseHelper.getData();
//     setState(() {
//       dataList = fetchedData;
//     });
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _ageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('New Planting'),
//         centerTitle: true,
//       ),
//       body: Container(
//         child: Padding(
//           padding: EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Column(
//                 children: [
//                   //Textfields for seeds infomation
//                   MyTextField(
//                     myController: _nameController,
//                     fieldName: "name",
//                   ),
//                   SizedBox(height: 10.0),
//                   MyTextField(
//                     myController: _ageController,
//                     fieldName: "age",
//                   ),
//                   SizedBox(height: 10.0),
//                   ElevatedButton(
//                       onPressed: _saveData, child: const Text('Save User')),
//                 ],
//               ),
//               SizedBox(height: 30.0),
//               Expanded(
//                   child: ListView.builder(
//                 itemCount: dataList.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(dataList[index]['name']),
//                     subtitle: Text('Age:  ${dataList[index]['age']}'),
//                     trailing: Row(mainAxisSize: MainAxisSize.min, children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   UpdateUser(userId: dataList[index]['id']),
//                             ),
//                           ).then((result) {
//                             if (result == true) {
//                               // Refresh the data on the current Screen
//                               fetchData();
//                             }
//                           });
//                         },
//                         icon: const Icon(
//                           Icons.edit,
//                           color: Colors.green,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           _delete(dataList[index]['id']);
//                         },
//                         icon: const Icon(
//                           Icons.delete,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ]),
//                   );
//                 },
//               ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyTextField extends StatelessWidget {
//   MyTextField({
//     Key? key,
//     required this.myController,
//     required this.fieldName,
//     this.myIcon = Icons.verified_user_outlined,
//     this.prefixIconColor = Colors.blueAccent,
//   });

//   final TextEditingController myController;
//   String fieldName;
//   final IconData myIcon;
//   Color prefixIconColor;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: myController,
//       decoration: InputDecoration(
//         labelText: fieldName,
//         border: const OutlineInputBorder(),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.green.shade300),
//         ),
//       ),
//     );
//   }
// }
