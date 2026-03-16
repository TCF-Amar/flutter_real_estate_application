import 'dart:io';
import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

Future<File?> showImagePreviewDialog(BuildContext context, File image) async {
  final cropController = CropController();
  final ProfileController controller = Get.find();
  File? croppedFile;

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          height: 420,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(12),
                  child: Crop(
                    controller: cropController,
                    image: image.readAsBytesSync(),
                    aspectRatio: 1,
                    onCropped: (result) async {
                      if (result is CropSuccess) {
                        final bytes = result.croppedImage;
                        final dir = await getTemporaryDirectory();
                        final file = File(
                          '${dir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.png',
                        );
                        await file.writeAsBytes(bytes);

                        croppedFile = file;
                        Get.back();
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const AppText("Cancel"),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Obx(
                        () => AppButton(
                          text: "Upload",
                          isLoading: controller.isUploading,
                          onPressed: () {
                            cropController.crop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );

  return croppedFile;
}
