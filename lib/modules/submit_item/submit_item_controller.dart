import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SubmitItemController extends GetxController {
  var volumeController = TextEditingController();
  bool isBtnActive = false;

  final ImagePicker _picker = ImagePicker();
  var images = <File>[];

  Future<void> pickImage(ImageSource source) async {
    if (images.length >= 5) {
      Get.snackbar("Limit Reached", "You can only add up to 5 images.");
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      images.add(File(pickedFile.path));
      update();
    }
  }

  Future<void> pickMultipleImages() async {
    if (images.length >= 5) {
      Get.snackbar("Limit Reached", "You can only add up to 5 images.");
      return;
    }

    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      if (images.length + pickedFiles.length > 5) {
        Get.snackbar("Limit Exceeded", "You can only select up to 5 images.");
      }
      int availableSlots = 5 - images.length;
      images.addAll(
          pickedFiles.take(availableSlots).map((file) => File(file.path)));
    }
    update();
  }

  void removeImage(int index) {
    images.removeAt(index);
    update();
  }
}
