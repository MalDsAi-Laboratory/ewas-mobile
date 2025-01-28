import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(212, 16, 197, 6),
      title: Text('E-Was'),
      actions: [
        IconButton(
          icon: Icon(Icons.account_circle, size: 30),
          onPressed: () {
            // Add account/avatar action here
          },
        ),
      ],
    );
  }
}
