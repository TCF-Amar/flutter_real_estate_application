import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/services/booking_services.dart';
import 'package:real_estate_app/features/my_booking/models/visit_confirmation_model.dart';
import 'package:real_estate_app/features/shared/models/pagination_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_snackbar.dart';

class MyBookingController extends GetxController {
  final Logger log = Logger();
  final BookingServices bookingServices = Get.find();

  final scrollController = ScrollController();

  final Rxn<Failure> failure = Rxn();

  final visitList = <VisitResponseData>[].obs;

  final pendingVisitList = <VisitResponseData>[].obs;
  final cancelledVisitList = <VisitResponseData>[].obs;
  final completedVisitList = <VisitResponseData>[].obs;

  final visitLoading = false.obs;
  final visitLoadingMore = false.obs;

  final visitPagination = Rxn<PaginationModel>();

  @override
  void onInit() {
    super.onInit();

    getVisitList();

    ever(visitList, (_) {
      filterVisitList();
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// GET VISIT LIST

  Future<void> getVisitList() async {
    await _getVisitList(isRefresh: true);
  }

  Future<void> _getVisitList({bool isRefresh = true}) async {
    if (isRefresh) {
      visitLoading.value = true;
    }

    failure.value = null;

    final page = isRefresh ? 1 : (visitPagination.value?.currentPage ?? 0) + 1;

    final result = await bookingServices.getVisits(page: page);

    result.fold(
      (error) {
        failure.value = error;
        AppSnackbar.error(error.message);
      },

      (response) {
        visitPagination.value = response.pagination;

        if (isRefresh) {
          visitList.assignAll(response.data);
        } else {
          visitList.addAll(response.data);
        }
        filterVisitList();
      },
    );

    visitLoading.value = false;
  }

  /// LOAD MORE

  Future<void> loadMoreVisits() async {
    final pagination = visitPagination.value;

    if (pagination == null) return;

    if (pagination.currentPage >= pagination.lastPage) return;

    if (visitLoadingMore.value) return;

    visitLoadingMore.value = true;

    await _getVisitList(isRefresh: false);

    visitLoadingMore.value = false;
  }

  /// FILTER LIST

  void filterVisitList() {
    pendingVisitList.clear();
    cancelledVisitList.clear();
    completedVisitList.clear();

    for (final visit in visitList) {
      switch (visit.status.toLowerCase().trim()) {
        case "requested":
        case "pending":
          pendingVisitList.add(visit);
          break;

        case "canceled":
        case "cancelled":
          cancelledVisitList.add(visit);
          break;

        case "complete":
        case "completed":
          completedVisitList.add(visit);
          break;
      }
    }

    log.d("Filtered lists update - Pending: ${pendingVisitList.length}, Cancelled: ${cancelledVisitList.length}, Completed: ${completedVisitList.length}");
  }

  /// BOOK VISIT

  final visitBooking = false.obs;

  Future<bool> visitBook(VisitConfirmRequestModel model) async {
    visitBooking.value = true;

    failure.value = null;

    final result = await bookingServices.visitBooking(model);

    visitBooking.value = false;

    result.fold(
      (error) {
        failure.value = error;
        AppSnackbar.error(error.message);
      },

      (_) {
        AppSnackbar.success("Visit booked successfully");
      },
    );

    return result.isRight();
  }
}
