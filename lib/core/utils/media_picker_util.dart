import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

enum MediaType { image, video, both }

class MediaPickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<File>> pickMedia(
    BuildContext context, {
    bool allowMultiple = true,
    MediaType mediaType = MediaType.both,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Drag handle ──────────────────────────────────────────
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const AppText(
                  "Select Media",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 16),

                // ── Gallery ──────────────────────────────────────────────
                _PickerTile(
                  icon: Icons.photo_library_outlined,
                  label: "Gallery",
                  onTap: () async {
                    await _pickGallery(
                      pickedFiles,
                      mediaType: mediaType,
                      allowMultiple: allowMultiple,
                    );
                    Get.back();
                  },
                ),

                // ── Camera ───────────────────────────────────────────────
                _PickerTile(
                  icon: Icons.camera_alt_outlined,
                  label: "Camera",
                  onTap: () async {
                    await _pickCamera(pickedFiles, mediaType: mediaType);
                    Get.back();
                  },
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );

    return pickedFiles;
  }

  // ── Gallery: opens ONE native picker that shows images+videos together ────
  static Future<void> _pickGallery(
    List<File> pickedFiles, {
    required MediaType mediaType,
    required bool allowMultiple,
  }) async {
    switch (mediaType) {
      case MediaType.image:
        if (allowMultiple) {
          final images = await _picker.pickMultiImage();
          pickedFiles.addAll(images.map((e) => File(e.path)));
        } else {
          final image = await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) pickedFiles.add(File(image.path));
        }

      case MediaType.video:
        final video = await _picker.pickVideo(source: ImageSource.gallery);
        if (video != null) pickedFiles.add(File(video.path));

      case MediaType.both:
        if (allowMultiple) {
          // ✅ Single native gallery dialog — shows images & videos together
          final media = await _picker.pickMultipleMedia();
          pickedFiles.addAll(media.map((e) => File(e.path)));
        } else {
          final media = await _picker.pickMedia();
          if (media != null) pickedFiles.add(File(media.path));
        }
    }
  }

  // ── Camera: ask image or video when mediaType == both ────────────────────
  static Future<void> _pickCamera(
    List<File> pickedFiles, {
    required MediaType mediaType,
  }) async {
    switch (mediaType) {
      case MediaType.image:
        final image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) pickedFiles.add(File(image.path));

      case MediaType.video:
        final video = await _picker.pickVideo(source: ImageSource.camera);
        if (video != null) pickedFiles.add(File(video.path));

      case MediaType.both:
        // Camera can't show both at once — ask the user which they want
        final result = await Get.dialog<String>(
          AlertDialog(
            title: const AppText(
              "Camera",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            content: const AppText("What do you want to capture?"),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: 'image'),
                child: const Text("Photo"),
              ),
              TextButton(
                onPressed: () => Get.back(result: 'video'),
                child: const Text("Video"),
              ),
            ],
          ),
        );
        if (result == 'image') {
          final image = await _picker.pickImage(source: ImageSource.camera);
          if (image != null) pickedFiles.add(File(image.path));
        } else if (result == 'video') {
          final video = await _picker.pickVideo(source: ImageSource.camera);
          if (video != null) pickedFiles.add(File(video.path));
        }
    }
  }
}

// ── Private reusable tile ─────────────────────────────────────────────────────
class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, size: 26),
      title: AppText(label),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onTap,
    );
  }
}
