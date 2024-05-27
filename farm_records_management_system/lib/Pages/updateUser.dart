// import 'package:flutter/material.dart';
// import 'databaseHelper.dart';

// class UpdateUser extends StatefulWidget {
//   const UpdateUser({Key? key, required this.userId}) : super(key: key);
//   final int userId;

//   @override
//   State<UpdateUser> createState() => _UpdateUserState();
// }

// class _UpdateUserState extends State<UpdateUser> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();

//   void fetchData() async {
//     Map<String, dynamic>? data =
//         await DatabaseHelper.getStringData(widget.userId);
//     if (data != null) {
//       _nameController.text = data['name'];
//       _ageController.text = data['age'].toString();
//     }
//   }

//   @override
//   void initState() {
//     fetchData();
//     super.initState();
//   }

//   void _updateData(BuildContext context) async {
//     Map<String, dynamic> data = {
//       'name': _nameController.text,
//       'age': _ageController.text,
//     };
//     //print(data);

//     int id = await DatabaseHelper.updateData(widget.userId, data);
//     Navigator.pop(context, true);
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
//         title: const Text('Update User'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(hintText: 'Name'),
//             ),
//             TextFormField(
//               controller: _ageController,
//               decoration: const InputDecoration(hintText: 'Age'),
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   _updateData(context);
//                 },
//                 child: const Text('Update User'))
//           ],
//         ),
//       ),
//     );
//   }
// }
