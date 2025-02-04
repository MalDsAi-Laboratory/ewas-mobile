import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
    return File(pickedImage.path);
  } else {
    log('No image selected.');
    return null;
  }
}
