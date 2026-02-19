import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/home/models/home_response.dart';

class HomeServices extends GetxService {
  final DioHelper _dioHelper = Get.find<DioHelper>();

  FutureResult<HomepageResponse> getHomepageData() async {
    try {
      final response = await _dioHelper.request(
        ApiRequest(url: ApiEndpoints.getHomepageData, method: ApiMethod.get),
      );
      return Right(
        HomepageResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }
}
