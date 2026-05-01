import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_ui/modules/submit_item/submit_item_controller.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'dart:io';

/// Web-safe image display widget that uses Image.memory on web and Image.file on native.
class XFileImage extends StatelessWidget {
  final XFile? xfile;
  final File? file;
  final double? width;
  final double? height;
  final BoxFit fit;

  const XFileImage({
    super.key,
    this.xfile,
    this.file,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return FutureBuilder<Uint8List>(
        future: xfile != null ? xfile!.readAsBytes() : file!.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              width: width,
              height: height,
              fit: fit,
            );
          }
          return SizedBox(
            width: width,
            height: height,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
      );
    } else {
      return Image.file(
        file!,
        width: width,
        height: height,
        fit: fit,
      );
    }
  }
}

class ImagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetBuilder<SubmitItemController>(builder: (controller) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextandIconButton(
                buttonText: 'Add Images',
                onTap: controller.pickMultipleImages,
                iconData: Icons.photo_library,
                isBtnActive: controller.images.length < 5 ? true : false,
              ),
              SizedBox(width: 10.w),
              TextandIconButton(
                  buttonText: 'Capture Images',
                  onTap: () {
                    controller.pickImage(ImageSource.camera);
                  },
                  iconData: Icons.camera_alt,
                  isBtnActive: controller.images.length < 5 ? true : false),
            ],
          );
        }),
        SizedBox(height: 20.h),
        GetBuilder<SubmitItemController>(builder: (controller) {
          return Wrap(
            spacing: 8.0.w,
            runSpacing: 8.w,
            children: List.generate(controller.images.length, (index) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: XFileImage(
                      file: controller.images[index],
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.removeImage(index),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.close, color: Colors.white, size: 16.r),
                    ),
                  )
                ],
              );
            }),
          );
        })
      ],
    );
  }
}
