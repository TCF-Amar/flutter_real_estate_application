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

  final Rxn<Failure> failure = Rxn<Failure>();

  @override
  void onInit() {
    super.onInit();
    getVisitList();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreVisits();
      }
    });
  }

  final scrollController = ScrollController(

  );
  

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  //* book site visit

  final visitBooking = false.obs;
  bool get isVisitBooking => visitBooking.value;
  Future<bool> visitBook(VisitConfirmRequestModel model) async {
    visitBooking.value = true;
    failure.value = null;
    final result = await bookingServices.visitBooking(model);
    result.fold(
      (l) {
        failure.value = l;
        AppSnackbar.error(l.message);
        return false;
      },
      (r) {
        // Get.back();
        AppSnackbar.success('Visit booked successfully');
        return true;
      },
    );
    visitBooking.value = false;
    return result.isRight();
  }

  final visitPagination = Rxn<PaginationModel>();
  final visitList = <VisitResponseData>[].obs;
  final visitLoading = false.obs;

  Future<void> _getVisitList({bool isRefresh = true}) async {
    if (isRefresh) {
      visitLoading.value = true;
    }
    failure.value = null;

    final int page = isRefresh
        ? 1
        : (visitPagination.value?.currentPage ?? 0) + 1;

    final result = await bookingServices.getVisits(page: page);
    result.fold(
      (l) {
        failure.value = l;
        AppSnackbar.error(l.message);
      },
      (r) {
        log.d(r.data.map((e) => e.toJson()).toList());
        visitPagination.value = r.pagination;
        if (isRefresh) {
          visitList.value = [...r.data];
        } else {
          visitList.addAll(r.data);
        }
      },
    );
    visitLoading.value = false;
  }

  Future<void> loadMoreVisits() async {
    final pagination = visitPagination.value;
    if (pagination != null &&
        pagination.currentPage < pagination.lastPage &&
        !visitLoading.value) {
      await _getVisitList(isRefresh: false);
    }
  }

  void getVisitList() async {
    await _getVisitList();
  }
}
