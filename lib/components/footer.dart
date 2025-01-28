import 'package:flutter/material.dart';
import 'package:simple_ui/pages/CategoriesPage.dart';
import 'package:simple_ui/pages/CreateOrder.dart';
import 'package:simple_ui/pages/Home.dart';
import 'package:simple_ui/pages/Notification.dart';


class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;

  // Define the list of pages for each tab
  final List<Widget> _pages = [
    CategoriesPage(),
    CreateOrderPage(),
    HomePage(),
    NotificationsPage(),
  ];

  // Function to handle tab selection
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Create Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
