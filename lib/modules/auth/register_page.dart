import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ui/modules/auth/auth_controller.dart';
import 'package:simple_ui/modules/auth/components/map_screen.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_fields.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    Get.put(AuthController());

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:
          false, // Prevents UI shift when keyboard appears
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/scrapit_logo.png", height: 60.h),
                SizedBox(width: 10.w),
                InterText(
                  text: "Scrap It",
                  style: TextStyle(
                      fontSize: 26.sp,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            InterText(
                text: "Welcome to Scrap It",
                style: TextStyle(
                    fontSize: 23.sp,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 5.h),
            RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: "For Smarter, Greener ",
                style: GoogleFonts.bricolageGrotesque(
                    textStyle: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500)),
              ),
              TextSpan(
                text: "& ",
                style: GoogleFonts.bricolageGrotesque(
                    textStyle: TextStyle(
                        color: const Color.fromARGB(255, 27, 27, 27),
                        fontSize: 13.sp)),
              ),
              TextSpan(
                text: "Sustainable India",
                style: GoogleFonts.bricolageGrotesque(
                    textStyle: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500)),
              )
            ])),
            const SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              tabs: const [
                Tab(text: "Login"),
                Tab(text: "Register"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildLoginTab(),
                  buildRegisterTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginTab() {
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

  Widget buildRegisterTab() {
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
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFieldWithLightBorder(
                          height: 55.h,
                          hintText: "First Name",
                          icon: Icon(
                            Icons.person_3_outlined,
                            size: 25.r,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomTextFieldWithLightBorder(
                          height: 55.h,
                          hintText: "Last Name",
                          icon: Icon(
                            Icons.person_3_outlined,
                            size: 25.r,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFieldWithLightBorder(
                    height: 55.h,
                    hintText: "Mobile Number",
                    icon: Icon(
                      Icons.ring_volume_sharp,
                      size: 25.r,
                      color: Colors.grey,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFieldWithLightBorder(
                    height: 55.h,
                    hintText: "Email (Optional)",
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
                      // controller.password.value = val;
                    },
                  ),
                  SizedBox(height: 20.h),
                  ConfirmPasswordField(
                    height: 55.h,
                    textInputAction: TextInputAction.done,
                    width: MediaQuery.sizeOf(context).width,
                    hintText: "Confirm Password",
                    onChanged: (val) {
                      // controller.password.value = val;
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
                        fontSize: 14.sp,
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
                        Icons.monitor_heart_outlined,
                        size: 25.r,
                        color: Colors.grey,
                      ),
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                          color: Colors.black),
                      hoverColor: Colors.black,
                      focusColor: Colors.black,
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
                    hint: Text("Select Role"),
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
                                  vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      controller.selectedAddress.value.isEmpty
                                          ? "Tap to select location"
                                          : controller.selectedAddress.value,
                                      style: TextStyle(fontSize: 16),
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
                          onTap: () {},
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
