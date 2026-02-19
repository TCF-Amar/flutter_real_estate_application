import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/explore/models/property_filter_model.dart';

class PropertyServices extends GetxService {
  final DioHelper dioHelper = Get.find<DioHelper>();

  final city = "".obs;
  final propertyCategory = "";
  final bhk = [].obs;
  final minPrice = 0;
  final maxPrice = 0;
  final minArea = 0;
  final maxArea = 0;
  final amenities = [].obs;
  final listingCategory = "";
  final perPage = 10;
  final page = 1;

  FutureResult<PropertyFilterModel> getFilterData() async {
    try {
      final response = await dioHelper.request(
        ApiRequest(url: ApiEndpoints.filterData, method: ApiMethod.get),
      );
      return Right(PropertyFilterModel.fromJson(response.data));
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }
}
