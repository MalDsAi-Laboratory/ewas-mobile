import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ui/modules/auth/auth_controller.dart';
import 'package:simple_ui/modules/auth/components/map_screen.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_fields.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    return Container(
      padding: EdgeInsets.all(16.w),
      color: const Color.fromARGB(255, 251, 251, 251),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  CustomTextFieldWithLightBorder(
                    height: 55.h,
                    hintText: "eg: Rakesh123",
                    initialValue: controller.userId.value,
                    icon: Icon(
                      Icons.person_3_outlined,
                      size: 25.r,
                      color: Colors.grey,
                    ),
                    onChanged: (val) {
                      controller.userId.value = val;
                    },
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFieldWithLightBorder(
                          hintText: "First Name",
                          initialValue: controller.firstName.value,
                          icon: Icon(
                            Icons.person_3_outlined,
                            size: 25.r,
                            color: Colors.grey,
                          ),
                          onChanged: (val) {
                            controller.firstName.value = val;
                          },
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomTextFieldWithLightBorder(
                          height: 55.h,
                          initialValue: controller.lastName.value,
                          hintText: "Last Name",
                          icon: Icon(
                            Icons.person_3_outlined,
                            size: 25.r,
                            color: Colors.grey,
                          ),
                          onChanged: (val) {
                            controller.lastName.value = val;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFieldWithLightBorder(
                    height: 55.h,
                    initialValue: controller.mobileNumber.value,
                    hintText: "Mobile Number",
                    icon: Icon(
                      Icons.ring_volume_sharp,
                      size: 25.r,
                      color: Colors.grey,
                    ),
                    onChanged: (val) {
                      controller.mobileNumber.value = val;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFieldWithLightBorder(
                    initialValue: controller.email.value,
                    height: 55.h,
                    hintText: "Email (Optional)",
                    onChanged: (val) {
                      controller.email.value = val;
                    },
                    icon: Icon(
                      Icons.person_3_outlined,
                      size: 25.r,
                      color: Colors.grey,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.h),
                  PasswordField(
                    height: 55.h,
                    initialValue: controller.password.value,
                    textInputAction: TextInputAction.done,
                    width: MediaQuery.sizeOf(context).width,
                    hintText: "Password",
                    onChanged: (val) {
                      controller.password.value = val;
                    },
                  ),
                  SizedBox(height: 20.h),
                  ConfirmPasswordField(
                    height: 55.h,
                    initialValue: controller.confirmPassword.value,
                    textInputAction: TextInputAction.done,
                    width: MediaQuery.sizeOf(context).width,
                    hintText: "Confirm Password",
                    onChanged: (val) {
                      controller.confirmPassword.value = val;
                    },
                  ),
                  SizedBox(height: 20.h),
                  InterText(
                    text: 'Are you a seller or recycler?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.sp,
                        color: const Color.fromARGB(255, 117, 117, 117)),
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<String>(
                    elevation: 0,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                    dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                    focusColor: const Color.fromARGB(255, 180, 253, 182),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 214, 214, 214),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 230, 230, 230),
                          width: 1.0,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.only(left: 15.w, right: 15.w, bottom: 7.h),
                      prefixIcon: Icon(
                        Icons.person_3_outlined,
                        size: 25.r,
                        color: Colors.grey,
                      ),
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.sp,
                          color: Colors.black),
                      hoverColor: Colors.black,
                      focusColor: Colors.black,
                      fillColor: Colors.white,
                      filled: true,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                    items: ["Seller", "Recycler"].map((role) {
                      return DropdownMenuItem(value: role, child: Text(role));
                    }).toList(),
                    onChanged: (value) {},
                    value: controller.userRole.value,
                  ),
                  SizedBox(height: 20.h),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final result = await Get.to(() => MapScreen());

                          if (result != null) {
                            controller.setLocation(
                              LatLng(result['lat'], result['lon']),
                              result['address'],
                            );
                          }
                        },
                        child: Obx(() => Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14.h, horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Color.fromARGB(255, 230, 230, 230)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: AppColors.primaryColor,
                                    size: 25.r,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: InterText(
                                      text: controller
                                              .selectedAddress.value.isEmpty
                                          ? "Tap to select location"
                                          : controller.selectedAddress.value,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(child: Text("")),
                    ],
                  ),
                  Column(
                    children: [
                      RadialGradientButton(
                          buttonText: 'Sign Up',
                          onTap: () {
                            controller.registerUser();
                          },
                          isBtnActive: true),
                      SizedBox(height: 10.h),
                      InterText(
                        text:
                            "By registering, I agree to the terms and conditions",
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
