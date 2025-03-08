import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_fields.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController queryController = TextEditingController();
  final String phoneNumber = "+918148574923";
  // Replace with your WhatsApp number
  void openWhatsApp() async {
    final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: BricolageText(
          text: "Contact Us",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: AppBarButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BricolageText(
                    text: "Get in Touch",
                    style:
                        TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  BricolageText(
                    text: "Feel free to reach out to us for any inquiries.",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Icon(Icons.email,
                          color: AppColors.primaryColor, size: 25.r),
                      SizedBox(width: 10.w),
                      BricolageText(
                          text: "support@example.com",
                          style: TextStyle(fontSize: 16.sp)),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: AppColors.primaryColor,
                        size: 25.r,
                      ),
                      SizedBox(width: 10.w),
                      BricolageText(
                          text: "+91 98765 43210",
                          style: TextStyle(fontSize: 16.sp)),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFieldWithLightBorder(
                    height: 55.h,
                    hintText: "Enter your message",
                    onChanged: (val) {
                      setState(() {});
                    },
                    controller: queryController,
                    maxLines: 4,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
              Column(
                children: [
                  RadialGradientButton(
                    buttonText: "Submit",
                    onTap: () {},
                    isBtnActive:
                        queryController.text.trim().isNotEmpty ? true : false,
                  ),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 100.h),
        child: FloatingActionButton(
          onPressed: openWhatsApp,
          child: SvgPicture.asset("assets/icons/whatsapp.svg"),
          backgroundColor: Color.fromRGBO(80, 202, 93, 1.0),
        ),
      ),
    );
  }
}
