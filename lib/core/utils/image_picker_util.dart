import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage(BuildContext context) async {
    return await showModalBottomSheet<File>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppText(
                  "Select Image",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const AppText("Camera"),
                  onTap: () async {
                    final image = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );

                    Get.back(result: image != null ? File(image.path) : null);
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const AppText("Gallery"),
                  onTap: () async {
                    final image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );

                    Get.back(result: image != null ? File(image.path) : null);
                  },
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
