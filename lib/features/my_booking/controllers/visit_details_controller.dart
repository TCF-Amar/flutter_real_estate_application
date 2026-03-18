import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/booking_services.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/my_booking/controllers/my_booking_controller.dart';
import 'package:real_estate_app/features/my_booking/models/visit_detail_response.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_details/cancel_visit_dialog.dart';
import 'package:real_estate_app/features/property/models/review_request_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

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
      ReviewRequestModel(rating: rating, comment: commentController.text),
    );

    result.fold(
      (failure) {
        _isSubmittingReview.value = false;
        AppSnackbar.error(failure.message);
      },
      (success) {
        _isSubmittingReview.value = false;
        Get.dialog(
          const AppSuccessDialog(
            title: "Thank You!",
            message: "Your feedback has been submitted\nsuccessfully.",
          ),
        );
        commentController.clear();
        _rating.value = 0;
      },
    );
  }

  void buyProperty() {
    log.i("Buy Property clicked");
    AppSnackbar.info("Buy Property feature coming soon!");
  }

  void cancelVisit() async {
    final reasonController = TextEditingController();

    showDialog(
      context: Get.context!,
      builder: (context) {
        return CancelVisitDialog(
          reasonController: reasonController,
          isCancelling: _isCancellingVisit.value,
          onCancel: () async {
            Get.back();
            await _cancelVisit(reason: reasonController.text);
          },
        );
      },
    );
    // Get.dialog(
    //   CancelVisitDialog(
    //     reasonController: reasonController,
    //     isCancelling: _isCancellingVisit.value,
    //     onCancel: () async {
    //       await _cancelVisit(reason: reasonController.text);
    //       Get.back();
    //     },
    //   ),
    // );
  }

  final _isCancellingVisit = false.obs;
  bool get isCancellingVisit => _isCancellingVisit.value;

  Future<void> _cancelVisit({String? reason}) async {
    _isCancellingVisit.value = true;

    final result = await bookingServices.cancelVisit(
      visitId.toInt(),
      reason: reason?.trim().isEmpty ?? true ? null : reason,
    );

    result.fold(
      (failure) {
        _isCancellingVisit.value = false;
        AppSnackbar.error(failure.message);
      },
      (success) {
        _isCancellingVisit.value = false;
        Get.dialog(
          const AppSuccessDialog(
            title: "Cancelled!",
            message:
                "Your scheduled site visit has been\ncancelled successfully.",
          ),
        );
        getVisitDetails();
        // Refresh the main booking list
        try {
          final myBookingController = Get.find<MyBookingController>();
          myBookingController.getVisitList();
        } catch (e) {
          log.w("MyBookingController not found, skipping list refresh: $e");
        }
      },
    );
  }
}
