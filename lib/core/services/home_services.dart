import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/home/models/home_response.dart';

class HomeServices extends GetxService {
  final Logger log = Logger();
  final DioHelper _dioHelper = Get.find<DioHelper>();

  // ── Homepage Data ───────────────────────────────────────────

  FutureResult<HomepageResponse> getHomepageData() async {
    log.i('Fetching homepage data...');
    try {
      final response = await _dioHelper.request(
        ApiRequest(url: ApiEndpoints.getHomepageData, method: ApiMethod.get),
      );
      log.i('Homepage data fetched successfully');
      return Right(
        HomepageResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on AppException catch (e) {
      log.e('Fetch homepage data failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch homepage data failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }
}
