import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_ui/modules/auth/auth_controller.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_fields.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    return Container(
      padding: EdgeInsets.all(16.0.w),
      color: const Color.fromARGB(255, 249, 249, 249),
      child: Column(
        children: [
          SizedBox(height: 4.h),
          CustomTextFieldWithLightBorder(
            height: 55.h,
            hintText: "Enter your email / mobile number",
            icon: Icon(
              Icons.person_3_outlined,
              size: 25.r,
              color: Colors.grey,
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 20.h),
          PasswordField(
            height: 55.h,
            textInputAction: TextInputAction.done,
            width: MediaQuery.sizeOf(context).width,
            hintText: "Password",
            onChanged: (val) {
              controller.password.value = val;
            },
          ),
          SizedBox(height: 20.h),
          Spacer(),
          Column(
            children: [
              RadialGradientButton(
                  buttonText: 'Login', onTap: () {}, isBtnActive: true),
              SizedBox(height: 20.h),
              InterText(
                text: "By signing in, you agree to terms and conditions",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ],
      ),
    );
  }
}
