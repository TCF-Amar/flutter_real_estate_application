import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class MediaPickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<File>> pickMedia(
    BuildContext context, {
    bool allowMultiple = true,
  }) async {
    final List<File> pickedFiles = [];

    await showModalBottomSheet(
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
                  "Select Media",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const AppText("Gallery (Images)"),
                  onTap: () async {
                    if (allowMultiple) {
                      final images = await _picker.pickMultiImage();
                      pickedFiles.addAll(images.map((e) => File(e.path)));
                    } else {
                      final image = await _picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) pickedFiles.add(File(image.path));
                    }
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.videocam),
                  title: const AppText("Gallery (Video)"),
                  onTap: () async {
                    final video = await _picker.pickVideo(
                      source: ImageSource.gallery,
                    );
                    if (video != null) pickedFiles.add(File(video.path));
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const AppText("Camera (Image)"),
                  onTap: () async {
                    final image = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) pickedFiles.add(File(image.path));
                    Get.back();
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );

    return pickedFiles;
  }
}
