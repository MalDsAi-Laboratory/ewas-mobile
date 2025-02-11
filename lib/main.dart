import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/splash/splash_screen.dart';
import 'package:simple_ui/app_start_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  appStartServices();
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

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         body: SafeArea(
//           child: MyHomePage(),
//         ),
//       ),
//     );
//   }
// }

// const kWhite = Colors.white;

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final _items = <Order>[
//     Order(
//       id: 'id-1',
//       date: DateTime.now(),
//       number: 12,
//       intemNo: 20,
//       orderTotal: 20000,
//       status: OrderStatus.inProgress,
//     ),
//     Order(
//       id: 'id-2',
//       date: DateTime.now().subtract(Duration(days: 10)),
//       number: 10,
//       intemNo: 2,
//       orderTotal: 5000,
//       status: OrderStatus.delivered,
//     ),
//   ];
//   DateFormat dateFormate = DateFormat.yMd();

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       separatorBuilder: (context, index) => Divider(
//         indent: 10.0,
//         endIndent: 10.0,
//         color: Colors.black,
//       ),
//       itemCount: _items.length,
//       itemBuilder: (context, index) {
//         var item = _items[index];

//         return Dismissible(
//           direction: DismissDirection.startToEnd,
//           key: Key(item.id),
//           onDismissed: (dir) {
//             setState(() => _items.removeAt(index));
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(dir == DismissDirection.startToEnd
//                     ? '$item removed.'
//                     : '$item liked.'),
//                 action: SnackBarAction(
//                   label: 'UNDO',
//                   onPressed: () {
//                     setState(() => _items.insert(index, item));
//                   },
//                 ),
//               ),
//             );
//           },
//           background: Container(
//             color: Colors.red,
//             padding: EdgeInsets.all(10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Icon(
//                   Icons.time_to_leave,
//                   color: kWhite,
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Cancel \n Order',
//                   style: TextStyle(color: kWhite),
//                 )
//               ],
//             ),
//             alignment: Alignment.centerLeft,
//           ),
//           child: ListTile(
//             title: Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text(
//                         'Order No: ${item.number}',
//                       ),
//                       Text('items no: ${item.intemNo}'),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text(
//                         'Order Total: ${item.orderTotal}',
//                       ),
//                       Text(dateFormate.format(item.date)),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   StatusBar(
//                     status: item.status,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class StatusBar extends StatelessWidget {
//   const StatusBar({Key? key, required this.status}) : super(key: key);

//   final OrderStatus status;
//   final List<String> titles = const [
//     'waiting',
//     'in progress',
//     'delivering',
//     'delivered'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     var checkedCount = _getCheckedCount(status);
//     var elements = List<bool>.generate(4, (i) => i < checkedCount);

//     return Column(
//       children: <Widget>[
//         Stack(
//           children: [
//             Positioned(
//               top: 10,
//               left: 10,
//               right: 10,

//               child: Container(
//                 height: 4,
//                 color: Colors.black38,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: elements
//                   .asMap()
//                   .map((index, isChecked) => MapEntry(
//                         index,
//                         Column(
//                           children: <Widget>[
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.deepOrange,
//                               ),
//                               alignment: Alignment.center,
//                               width: 20,
//                               height: 20,
//                               child: isChecked ? Icon(Icons.check) : null,
//                             ),
//                             Text(titles[index])
//                           ],
//                         ),
//                       ))
//                   .values
//                   .toList(),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   _getCheckedCount(OrderStatus status) {
//     switch (status) {
//       case OrderStatus.waiting:
//         return 1;
//       case OrderStatus.inProgress:
//         return 2;
//       case OrderStatus.deliviring:
//         return 3;
//       case OrderStatus.delivered:
//         return 4;
//     }
//   }
// }

// class Order {
//   final String id;
//   final int number;
//   final int intemNo;
//   final int orderTotal;
//   final DateTime date;
//   final OrderStatus status;

//   Order({
//     required this.id,
//     required this.number,
//     required this.intemNo,
//     required this.orderTotal,
//     required this.date,
//     required this.status,
//   });
// }

// enum OrderStatus { waiting, inProgress, deliviring, delivered }
