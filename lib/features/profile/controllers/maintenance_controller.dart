import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/maintenance_services.dart';
import 'package:real_estate_app/core/utils/media_picker_util.dart';
import 'package:real_estate_app/features/profile/models/maintenance_request_model.dart';
import 'package:real_estate_app/features/shared/models/pagination_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class MaintenanceController extends GetxController {
  final log = Logger();
  final maintenanceServices = Get.find<MaintenanceServices>();
  final RxList<File> pickedMedia = <File>[].obs;
  final RxList<File> pickedImages = <File>[].obs;
  final RxList<File> pickedVideos = <File>[].obs;
  final propertyScrollController = ScrollController();

  final RxList<MaintenanceRequestModel> maintenanceList =
      <MaintenanceRequestModel>[].obs;
  final RxBool isMaintenanceLoading = false.obs;
  final RxBool isMoreMaintenanceLoading = false.obs;
  final Rxn<PaginationModel> maintenancePagination = Rxn<PaginationModel>();
  final RxInt selectedTabIndex = 0.obs;

  final Rxn<MaintenanceDetailModel> maintenanceDetail =
      Rxn<MaintenanceDetailModel>();
  final RxBool isDetailLoading = false.obs;

  List<MaintenanceRequestModel> get activeRequests => maintenanceList
      .where(
        (e) =>
            e.status == MaintenanceStatus.open ||
            e.status == MaintenanceStatus.in_progress,
      )
      .toList();

  List<MaintenanceRequestModel> get pastRequests => maintenanceList
      .where(
        (e) =>
            e.status == MaintenanceStatus.completed ||
            e.status == MaintenanceStatus.closed,
      )
      .toList();

  @override
  void onInit() {
    super.onInit();
    getMaintenanceRequests();
    propertyScrollController.addListener(() {
      if (propertyScrollController.position.pixels >=
          propertyScrollController.position.maxScrollExtent - 100) {
        loadMoreMaintenanceRequests();
      }
    });
  }

  @override
  void onClose() {
    propertyScrollController.dispose();
    super.onClose();
  }

  Future<void> getMaintenanceRequests() async {
    await _getMaintenanceRequests(isRefresh: true);
  }

  Future<void> _getMaintenanceRequests({bool isRefresh = true}) async {
    if (isRefresh) {
      isMaintenanceLoading.value = true;
    } else {
      isMoreMaintenanceLoading.value = true;
    }

    final page = isRefresh
        ? 1
        : (maintenancePagination.value?.currentPage ?? 0) + 1;

    final result = await maintenanceServices.getMaintenanceRequests(page: page);

    result.fold((l) => AppSnackbar.error(l.message), (r) {
      maintenancePagination.value = r.data.pagination;
      log.d(r.data.pagination.total);
      if (isRefresh) {
        maintenanceList.assignAll(r.data.requests);
      } else {
        maintenanceList.addAll(r.data.requests);
        log.d(maintenanceList.length);
      }
    });

    if (isRefresh) {
      isMaintenanceLoading.value = false;
    } else {
      isMoreMaintenanceLoading.value = false;
    }

    if (activeRequests.length < 10 || pastRequests.length < 10) {
      final pagination = maintenancePagination.value;
      if (pagination != null && pagination.currentPage < pagination.lastPage) {
        loadMoreMaintenanceRequests();
      }
    }
  }

  Future<void> loadMoreMaintenanceRequests() async {
    final pagination = maintenancePagination.value;
    if (pagination == null) return;
    if (pagination.currentPage >= pagination.lastPage) return;
    if (isMoreMaintenanceLoading.value) return;

    await _getMaintenanceRequests(isRefresh: false);
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

  Future<void> getMaintenanceDetails(int id) async {
    isDetailLoading.value = true;
    maintenanceDetail.value = null;

    final result = await maintenanceServices.getMaintenanceDetails(id);

    result.fold(
      (l) => AppSnackbar.error(l.message),
      (r) {
        maintenanceDetail.value = r.data;
      },
    );

    isDetailLoading.value = false;
  }
}
