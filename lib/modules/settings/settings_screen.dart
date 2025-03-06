import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/ui_utils/common_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: BricolageText(text: "Settings"),
        ),
        body: SafeArea(
          child: Center(
              child:
                  SizedBox(width: 150.w, height: 55.h, child: LogOutButton())),
        ));
  }
}
