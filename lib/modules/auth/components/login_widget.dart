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
            hintText: "Enter your user id",
            onChanged: (val) {
              controller.userId.value = val;
            },
            initialValue: controller.userId.value,
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
            initialValue: controller.password.value,
            hintText: "Password",
            onChanged: (val) {
              controller.password.value = val;
            },
          ),
          SizedBox(height: 20.h),
          Spacer(),
          Column(
            children: [
              Obx(
                () => controller.isLoading.value
                    ? RadialGradientButtonWithWidget(
                        buttonChild: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        onTap: () {},
                        isBtnActive: true)
                    : RadialGradientButton(
                        buttonText: 'Login',
                        onTap: controller.loginUser,
                        isBtnActive: true),
              ),
              SizedBox(height: 16.h),
              // ── OR divider ───────────────────────────────────────────────
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: InterText(
                      text: "OR",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              SizedBox(height: 16.h),
              // ── Google Sign-In button ─────────────────────────────────────
              Obx(
                () => GestureDetector(
                  onTap: controller.isLoading.value
                      ? null
                      : () => controller.loginWithGoogle(),
                  child: Container(
                    width: double.infinity,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                          height: 22.h,
                          width: 22.h,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.g_mobiledata_rounded,
                            size: 24.r,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        InterText(
                          text: "Continue with Google",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
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
