import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Farmer App'),
      backgroundColor: Colors.green,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
