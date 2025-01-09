import 'package:flutter/material.dart';
import 'package:simple_ui/components/header.dart';
import 'package:simple_ui/components/content.dart';
import 'package:simple_ui/components/footer.dart';
import 'package:simple_ui/components/carousal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Header(),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: CarouselWithSlider(),
            ),
            Expanded(
              flex: 3,
              child: Content(),
            ),
          ],
        ),
        bottomNavigationBar: Footer(),
      ),
    );
  }
}


