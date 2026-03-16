import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/my_booking/models/visit_confirmation_model.dart';

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
    int? parPage = 5,
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
      log.d('Get visit confirm response: ${response.data}');
      log.i('Visit confirm fetched successfully');
      final res = VisitResponse.fromJson(response.data);
      log.d(res.toJson());
      return Right(res);
    } on AppException catch (e) {
      log.e('Get visit confirm failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Get visit confirm failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }
}
