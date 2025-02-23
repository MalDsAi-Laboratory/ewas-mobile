import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/splash/splash_screen.dart';
import 'package:simple_ui/services/secure_storage/user_caching.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            try {
              await SecureStorageServices().logOut();
              Get.off(() => SplashScreen());
            } catch (e) {
              log("error in logOut $e");
            }
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: Image.network(
                'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
                width: 40.w,
                height: 40.w,
              )),
        ),
        SizedBox(
          width: 15.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BricolageText(
              text: "Hi !",
              style: TextStyle(fontSize: 14.sp),
            ),
            BricolageText(
              text: "Let's sell your e-waste",
              style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color.fromARGB(255, 124, 124, 124)),
            ),
          ],
        )
      ],
    );
  }
}
