import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/booking_services.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/my_booking/models/visit_detail_response.dart';
import 'package:real_estate_app/features/property/models/review_request_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_snackbar.dart';

class VisitDetailsController extends GetxController {
  final log = Logger();
  final BookingServices bookingServices = Get.find();
  final PropertyServices propertyServices = Get.find();
  final visitId = Get.arguments;

  final commentController = TextEditingController();
  final _rating = 0.obs;
  final _commentLength = 0.obs;
  final _isSubmittingReview = false.obs;

  int get rating => _rating.value;
  int get commentLength => _commentLength.value;
  bool get isSubmittingReview => _isSubmittingReview.value;

  void setRating(int value) => _rating.value = value;

  @override
  void onInit() {
    super.onInit();
    getVisitDetails();
    commentController.addListener(() {
      _commentLength.value = commentController.text.length;
    });
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  final visitDetails = Rxn<VisitDetailResponse>();
  final visitLoading = false.obs;

  Future<void> getVisitDetails() async {
    visitLoading.value = true;
    final result = await bookingServices.getVisitDetails(visitId.toInt());
    result.fold(
      (failure) {
        visitLoading.value = false;
        AppSnackbar.error(failure.message);
      },
      (visitDetailResponse) {
        visitDetails.value = visitDetailResponse;
        log.d("Visit Details: ${visitDetailResponse.toJson()}");
        visitLoading.value = false;
      },
    );
  }

  Future<void> addReview() async {
    final propertyId = visitDetails.value?.data?.property?.id;
    if (propertyId == null) {
      AppSnackbar.error("Property ID not found");
      return;
    }

    if (rating == 0) {
      AppSnackbar.info("Please select a rating");
      return;
    }

    _isSubmittingReview.value = true;
    final result = await propertyServices.addReview(
      propertyId,
      ReviewRequestModel(
        rating: rating,
        comment: commentController.text,
      ),
    );

    result.fold(
      (failure) {
        _isSubmittingReview.value = false;
        AppSnackbar.error(failure.message);
      },
      (success) {
        _isSubmittingReview.value = false;
        AppSnackbar.success("Review submitted successfully");
        commentController.clear();
        _rating.value = 0;
      },
    );
  }

  void buyProperty() {
    log.i("Buy Property clicked");
    AppSnackbar.info("Buy Property feature coming soon!");
  }

  void cancelVisit() {
    log.i("Cancel Visit clicked");
    AppSnackbar.info("Cancel Visit feature coming soon!");
  }
}
