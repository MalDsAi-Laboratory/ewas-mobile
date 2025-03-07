import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_ui/modules/auth/auth_controller.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class CustomFieldWithleadingAndActionIcon extends StatelessWidget {
  final double? width;
  final String? FieldName;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? initialValue;
  final double? borderRadius;
  final Function()? onPressOfSearchButton;
  const CustomFieldWithleadingAndActionIcon({
    super.key,
    this.validator,
    this.width,
    this.FieldName,
    this.keyboardType,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.onPressOfSearchButton,
    this.hintText,
    this.borderRadius = 10,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldName != null && FieldName!.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Column(
                  children: [
                    BricolageText(
                      text: FieldName ?? "",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.h,
                    )
                  ],
                ),
              )
            : SizedBox(),
        SizedBox(
          height: 45.h,
          width: width,
          child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: keyboardType ?? TextInputType.text,
              cursorColor: Colors.black,
              onChanged: onChanged,
              controller: controller,
              cursorWidth: 1,
              initialValue: initialValue,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 24.sp,
                    ),
                    onPressed: onPressOfSearchButton ?? () {},
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color(0xff0033ff),
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 7, left: 10),
                  filled: true,
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 240, 8, 8),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 144, 144, 144),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color(0xff0033ff),
                      width: 2.0,
                    ),
                  ),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  hintText: hintText,
                  hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: const Color.fromARGB(255, 171, 171, 171)))),
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final double? width;
  final String? FieldName;
  final Widget? icon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? initialValue;
  final double? borderRadius;
  final Function()? onPressOfSearchButton;
  final double? height;
  final int? maxLines;
  const CustomTextField(
      {super.key,
      this.validator,
      this.width,
      this.FieldName,
      this.keyboardType,
      this.controller,
      this.onChanged,
      this.initialValue,
      this.onPressOfSearchButton,
      this.hintText,
      this.borderRadius = 10,
      this.icon,
      this.height,
      this.maxLines = 1});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldName != null && FieldName!.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Column(
                  children: [
                    BricolageText(
                      text: FieldName ?? "",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.h,
                    )
                  ],
                ),
              )
            : SizedBox(),
        SizedBox(
          height: height != null ? height!.h : 45.h,
          width: width,
          child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: keyboardType ?? TextInputType.text,
              cursorColor: Colors.black,
              onChanged: onChanged,
              controller: controller,
              maxLines: maxLines,
              cursorWidth: 1,
              initialValue: initialValue,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  prefixIcon: icon,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color(0xff0033ff),
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 7, left: 10),
                  filled: true,
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 240, 8, 8),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 144, 144, 144),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color(0xff0033ff),
                      width: 2.0,
                    ),
                  ),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  hintText: hintText,
                  hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: const Color.fromARGB(255, 171, 171, 171)))),
        ),
      ],
    );
  }
}

class CustomTextFieldWithLightBorder extends StatelessWidget {
  final double? width;
  final String? FieldName;
  final Widget? icon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? initialValue;
  final double? borderRadius;
  final Function()? onPressOfSearchButton;
  final double? height;
  final int? maxLines;
  const CustomTextFieldWithLightBorder(
      {super.key,
      this.validator,
      this.width,
      this.FieldName,
      this.keyboardType,
      this.controller,
      this.onChanged,
      this.initialValue,
      this.onPressOfSearchButton,
      this.hintText,
      this.borderRadius = 10,
      this.icon,
      this.height,
      this.maxLines = 1});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldName != null && FieldName!.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Column(
                  children: [
                    BricolageText(
                      text: FieldName ?? "",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    )
                  ],
                ),
              )
            : SizedBox(),
        SizedBox(
          width: width,
          child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: keyboardType ?? TextInputType.text,
              cursorColor: Colors.black,
              onChanged: onChanged,
              controller: controller,
              maxLines: maxLines,
              cursorWidth: 1,
              initialValue: initialValue,
              validator: validator ??
                  (str) {
                    return null;
                  },
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  prefixIcon: icon,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 189, 189, 189),
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 7, left: 10),
                  filled: true,
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 240, 8, 8),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 230, 230, 230),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 214, 214, 214),
                      width: 1.0,
                    ),
                  ),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  hintText: hintText,
                  hintStyle: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 171, 171, 171))))),
        ),
      ],
    );
  }
}

class PasswordField extends StatelessWidget {
  final double width;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final String? hintText;
  final String? Function(String?)? validator;
  final double? height;
  final String? initialValue;
  const PasswordField({
    super.key,
    required this.width,
    required this.textInputAction,
    this.onChanged,
    this.hintText,
    this.validator,
    this.height = 45,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    return Container(
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15.w),
            ),
            color: Colors.white),
        child: Obx(() => TextFormField(
            initialValue: initialValue ?? "",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: Colors.black,
            onChanged: onChanged,
            cursorWidth: 1,
            obscureText: controller.isObscure.value,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                size: 25.r,
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                icon: Icon(controller.isObscure.value
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  controller.isObscure.value = !controller.isObscure.value;
                },
              ),
              contentPadding:
                  EdgeInsets.only(bottom: 0, left: 10.w, right: 10.w),
              filled: true,
              fillColor: const Color.fromARGB(0, 255, 255, 255),
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Color.fromARGB(255, 171, 171, 171))),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color.fromARGB(0, 0, 51, 255),
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color.fromARGB(0, 240, 8, 8),
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 230, 230, 230),
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 170, 170, 170),
                  width: 1.0,
                ),
              ),
            ))));
  }
}

class ConfirmPasswordField extends StatelessWidget {
  final double width;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final String? hintText;
  final String? Function(String?)? validator;
  final double? height;
  final String? initialValue;
  const ConfirmPasswordField({
    super.key,
    required this.width,
    required this.textInputAction,
    this.onChanged,
    this.hintText,
    this.validator,
    this.height = 45,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();

    return Container(
        width: width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            color: Colors.white),
        child: Obx(() => TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: Colors.black,
            onChanged: onChanged,
            initialValue: initialValue ?? "",
            cursorWidth: 1,
            obscureText: controller.isConfirmObscure.value,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  size: 25.r,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  icon: Icon(controller.isConfirmObscure.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    controller.isConfirmObscure.value =
                        !controller.isConfirmObscure.value;
                    controller.update();
                  },
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(0, 0, 51, 255),
                    width: 1.0,
                  ),
                ),
                contentPadding:
                    EdgeInsets.only(bottom: 0, left: 10.w, right: 10.w),
                filled: true,
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(0, 240, 8, 8),
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 215, 215, 215),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 170, 170, 170),
                    width: 1.0,
                  ),
                ),
                fillColor: const Color.fromARGB(0, 255, 255, 255),
                hintText: hintText,
                hintStyle: GoogleFonts.bricolageGrotesque(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        color: const Color.fromARGB(255, 171, 171, 171)))))));
  }
}
