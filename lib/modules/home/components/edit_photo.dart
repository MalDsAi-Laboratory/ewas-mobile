import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';

class EditableProfileAvatar extends StatefulWidget {
  const EditableProfileAvatar({super.key});

  @override
  _EditableProfileAvatarState createState() => _EditableProfileAvatarState();
}

class _EditableProfileAvatarState extends State<EditableProfileAvatar> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final profileImagePath = '${directory.path}/profile/profile.jpg';
    final profileImageFile = File(profileImagePath);

    if (await profileImageFile.exists()) {
      setState(() {
        _profileImage = profileImageFile;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final profileDir = Directory('${directory.path}/profile');

      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      final savedImage = File('${profileDir.path}/profile.jpg');
      await File(pickedFile.path).copy(savedImage.path);

      setState(() {
        _profileImage = savedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
            image: _profileImage != null
                ? DecorationImage(
                    image: FileImage(_profileImage!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: _profileImage == null
              ? Icon(Icons.person, size: 50.r, color: Colors.grey)
              : null,
        ),
        Positioned(
          bottom: 5.h,
          right: 5.w,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(Icons.edit, size: 18.r, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
