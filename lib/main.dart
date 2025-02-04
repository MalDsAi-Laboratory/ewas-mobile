import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/splash/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844), // Set the design size parameters
        builder: (context, child) {
          return GetMaterialApp(
            title: 'ScrapIt',
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        });
  }
}

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 2;

//   // Footer Tab Index Mapping
//   final List<Widget> _tabContents = [
//     Center(
//       child: Text(
//         'Categories Tab',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     ),
//     Center(
//       child: Text(
//         'Create Order Tab',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     ),
//     HomePage(),
//     Center(
//       child: Text(
//         'Notifications Tab',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     ),
//   ];

//   void _onTabSelected(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: Header(),
//       ),
//       body: _tabContents[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onTabSelected,
//         type: BottomNavigationBarType.fixed,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.category),
//             label: 'Categories',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_circle),
//             label: 'Create Order',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             label: 'Notifications',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           flex: 2,
//           child: CarouselWithSlider(),
//         ),
//         Expanded(
//           flex: 3,
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     print('Sell your E-Waste button pressed');
//                   },
//                   child: Text('Sell your E-Waste'),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(200, 50),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     print('View E-Waste Around You button pressed');
//                   },
//                   child: Text('View E-Waste Around You'),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(200, 50),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => OpenStreetMapPage(),
//                       ),
//                     );
//                   },
//                   child: Text('Open Map'),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(200, 50),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
