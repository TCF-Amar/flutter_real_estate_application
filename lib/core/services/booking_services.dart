import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/my_booking/models/my_booking_model.dart';
import 'package:real_estate_app/features/my_booking/models/visit_confirmation_model.dart';
import 'package:real_estate_app/features/my_booking/models/visit_detail_response.dart';

class BookingServices {
  final Logger log = Logger();
  final DioHelper dioHelper = Get.find<DioHelper>();

  FutureResult<void> visitBooking(VisitConfirmRequestModel model) async {
    log.i('Visiting booking...');
    try {
      await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.visitBook,
          method: ApiMethod.post,
          body: model.toJson(),
        ),
      );
      log.i('Booking visited successfully');
      return const Right(null);
    } on AppException catch (e) {
      log.e('Visit booking failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Visit booking failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  FutureResult<VisitResponse> getVisits({
    int? parPage = 10,
    int? page = 1,
  }) async {
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.getVisits,
          method: ApiMethod.get,
          queryParameters: {'per_page': parPage, 'page': page},
        ),
      );
      // log.d('Get visit confirm response: ${response.data}');0
      // log.d(response.data);
      log.i('Visit confirm fetched successfully');
      log.d(VisitResponse.fromJson(response.data));
      return Right(VisitResponse.fromJson(response.data));
    } on AppException catch (e) {
      log.e('Get visit confirm failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Get visit confirm failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  FutureResult<VisitDetailResponse> getVisitDetails(int id) async {
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.getVisitDetails(id),
          method: ApiMethod.get,
        ),
      );
      log.i('Visit details fetched successfully');
      final res = VisitDetailResponse.fromJson(response.data);
      return Right(res);
    } on AppException catch (e) {
      log.e('Get visit confirm failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Get visit confirm failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  FutureResult<void> cancelVisit(int id, {String? reason}) async {
    try {
      await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.cancelVisit(id),
          method: ApiMethod.post,
          body: reason != null ? {'reason': reason} : null,
        ),
      );
      log.i('Visit cancelled successfully');
      return const Right(null);
    } on AppException catch (e) {
      log.e('Visit cancel failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Visit cancel failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  FutureResult<BookingResponse> getMyBookings({
    int? parPage = 10,
    int? page = 1,
  }) async {
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.getBookedProperties,
          method: ApiMethod.get,
          queryParameters: {'per_page': parPage, 'page': page},
        ),
      );

      // log.d(response.data);

      return Right(BookingResponse.fromJson(response.data));
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  FutureResult<BookingDetailResponse> getBookingDetails(int id) async {
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.getBookingDetails(id),
          method: ApiMethod.get,
        ),
      );
      log.i('Booking details fetched successfully');
      final res = BookingDetailResponse.fromJson(response.data);
      return Right(res);
    } on AppException catch (e) {
      log.e('Get booking details failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Get booking details failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }
}
