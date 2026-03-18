import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/utils/media_picker_util.dart';

class MaintenanceController extends GetxController {
  final RxList<File> pickedMedia = <File>[].obs;
  final RxList<File> pickedImages = <File>[].obs;
  final RxList<File> pickedVideos = <File>[].obs;

  Future<void> pickMedia(BuildContext context) async {
    final results = await MediaPickerUtil.pickMedia(context);
    if (results.isNotEmpty) {
      pickedMedia.addAll(results);
      for (var file in results) {
        if (file.path.toLowerCase().endsWith('.mp4')) {
          pickedVideos.add(file);
        } else {
          pickedImages.add(file);
        }
      }
    }
  }

  void removeMedia(int index) {
    var file = pickedMedia.removeAt(index);
    pickedImages.remove(file);
    pickedVideos.remove(file);
  }

  void removeImage(int index) {
    var file = pickedImages.removeAt(index);
    pickedMedia.remove(file);
  }

  void removeVideo(int index) {
    var file = pickedVideos.removeAt(index);
    pickedMedia.remove(file);
  }
}
