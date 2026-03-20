import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/services/maintenance_services.dart';
import 'package:real_estate_app/core/utils/media_picker_util.dart';
import 'package:real_estate_app/features/my_booking/controllers/my_booking_controller.dart';
import 'package:real_estate_app/features/profile/models/maintenance_request_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class MaintenanceController extends GetxController {
  final maintenanceServices = Get.find<MaintenanceServices>();
  final RxList<File> pickedMedia = <File>[].obs;
  final RxList<File> pickedImages = <File>[].obs;
  final RxList<File> pickedVideos = <File>[].obs;
  final propertyScrollController = ScrollController();

  final RxList<MaintenanceRequestModel> maintenanceList = <MaintenanceRequestModel>[].obs;
  final RxBool isMaintenanceLoading = false.obs;

  List<MaintenanceRequestModel> get activeRequests =>
      maintenanceList.where((e) => e.status == 'open' || e.status == 'in_progress').toList();

  List<MaintenanceRequestModel> get pastRequests =>
      maintenanceList.where((e) => e.status == 'complete' || e.status == 'cancelled').toList();

  @override
  void onInit() {
    super.onInit();
    getMaintenanceRequests();
    propertyScrollController.addListener(() {
      if (propertyScrollController.position.pixels >=
          propertyScrollController.position.maxScrollExtent - 100) {
        Get.find<MyBookingController>().loadMoreBookings();
      }
    });
  }

  @override
  void onClose() {
    propertyScrollController.dispose();
    super.onClose();
  }

  Future<void> getMaintenanceRequests() async {
    isMaintenanceLoading.value = true;
    final result = await maintenanceServices.getMaintenanceRequests();
    result.fold(
      (l) => AppSnackbar.error(l.message),
      (r) => maintenanceList.assignAll(r),
    );
    isMaintenanceLoading.value = false;
  }

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

  final pid = RxnInt();
  final title = "".obs;
  final message = "".obs;
  final category = "".obs;

  void sendMaintenanceRequest() async {
    if (pid.value == null) {
      AppSnackbar.error("Please select a property");
      return;
    }
    if (title.value.isEmpty) {
      AppSnackbar.error("Please enter a title");
      return;
    }
    if (category.value.isEmpty) {
      AppSnackbar.error("Please select a category");
      return;
    }
    if (message.value.isEmpty) {
      AppSnackbar.error("Please enter a message");
      return;
    }
    await _sendMaintenanceRequest();
  }

  Future<void> _sendMaintenanceRequest() async {
    final result = await maintenanceServices.sendMaintenanceRequest(
      pid: pid.value.toString(),
      title: title.value,
      category: category.value,
      description: message.value,
      images: pickedImages,
      videos: pickedVideos,
    );
    result.fold(
      (l) {
        AppSnackbar.error(l.message);
      },
      (_) {
        Get.back();
        getMaintenanceRequests(); 
        AppSnackbar.success("Maintenance request sent successfully");
      },
    );
  }
}
