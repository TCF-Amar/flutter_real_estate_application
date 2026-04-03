import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/services/booking_services.dart';
import 'package:real_estate_app/features/my_booking/models/bkp.dart';
import 'package:real_estate_app/features/my_booking/models/my_booking_model.dart';
import 'package:real_estate_app/features/my_booking/models/visit_confirmation_model.dart';
import 'package:real_estate_app/features/shared/models/pagination_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_snackbar.dart';

class MyBookingController extends GetxController {
  final Logger log = Logger();
  final BookingServices bookingServices = Get.find();

  final scrollController = ScrollController();
  final bookingScrollController = ScrollController();

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
    getMyBookings();

    // Site Visits Scroll Listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreVisits();
      }
    });

    // Bookings Scroll Listener
    bookingScrollController.addListener(() {
      if (bookingScrollController.position.pixels >=
          bookingScrollController.position.maxScrollExtent - 200) {
        loadMoreBookings();
      }
    });

    ever(visitList, (_) {
      filterVisitList();
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    bookingScrollController.dispose();
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

    log.d(
      "Filtered lists update - Pending: ${pendingVisitList.length}, Cancelled: ${cancelledVisitList.length}, Completed: ${completedVisitList.length}",
    );

    // Fetch more if pending list has fewer than 10 items
    if (pendingVisitList.length < 10 && pendingVisitList.isNotEmpty) {
      loadMoreVisits();
    }

    // Fetch more if cancelled list has fewer than 10 items
    if (cancelledVisitList.length < 10 && cancelledVisitList.isNotEmpty) {
      loadMoreVisits();
    }
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

  final myBookings = <Booking>[].obs;
  final bkpl = <Bkp>[].obs;
  final bookingPagination = Rxn<PaginationModel>();
  final bookingLoading = false.obs;
  final bookingLoadingMore = false.obs;

  Future<void> _getMyBookings({bool isRefresh = true}) async {
    if (isRefresh) {
      bookingLoading.value = true;
    }
    final page = isRefresh
        ? 1
        : (bookingPagination.value?.currentPage ?? 0) + 1;
    final result = await bookingServices.getMyBookings(page: page);

    result.fold(
      (error) {
        failure.value = error;
        AppSnackbar.error(error.message);
      },

      (response) {
        bookingPagination.value = response.data.pagination;
        if (isRefresh) {
          myBookings.assignAll(response.data.bookings);
          bkpl.assignAll(
            response.data.bookings.map(
              (e) =>
                  Bkp(pid: e.property!.id, title: e.property!.title ?? "N/A"),
            ),
          );
        } else {
          myBookings.addAll(response.data.bookings);
          bkpl.addAll(
            response.data.bookings.map(
              (e) =>
                  Bkp(pid: e.property!.id, title: e.property!.title ?? "N/A"),
            ),
          );
        }
      },
    );
    bookingLoading.value = false;
  }

  Future<void> loadMoreBookings() async {
    final pagination = bookingPagination.value;

    if (pagination == null) return;

    if (pagination.currentPage >= pagination.lastPage) return;

    if (bookingLoadingMore.value) return;

    bookingLoadingMore.value = true;

    await _getMyBookings(isRefresh: false);

    bookingLoadingMore.value = false;
  }

  void getMyBookings() async {
    await _getMyBookings();
  }

  Future<void> refreshBooking() async {
    await _getMyBookings();
  }
}
