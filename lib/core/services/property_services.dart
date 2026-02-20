import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/explore/models/property_filter_model.dart';
import 'package:real_estate_app/features/explore/models/property_response.dart';

class PropertyServices extends GetxService {
  final DioHelper dioHelper = Get.find<DioHelper>();

  final city = "".obs;
  final propertyCategory = "";
  final bhk = <int>[].obs;
  final minPrice = 0.obs;
  final maxPrice = 100000000.obs;
  final RxnInt minArea = RxnInt();
  final RxnInt maxArea = RxnInt();
  final amenities = "".obs;
  final listingCategory = "".obs;
  final keywords = "".obs;
  final propertyStatus = "".obs;
  final perPage = 5.obs;

  final page = 1.obs;

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

  FutureResult<PropertyResponse> searchProperties() async {
    try {
      final queryParams = <String, dynamic>{
        "per_page": perPage.value,
        "page": page.value,
      };

      if (keywords.value.isNotEmpty) queryParams["title"] = keywords.value;
      if (city.value.isNotEmpty) queryParams["city"] = city.value;
      if (propertyCategory.isNotEmpty) {
        queryParams["property_category"] = propertyCategory;
      }
      if (bhk.isNotEmpty) queryParams["bhk"] = bhk.join(",");
      if (minPrice.value > 0) queryParams["min_price"] = minPrice.value;
      if (maxPrice.value < 100000000) {
        queryParams["max_price"] = maxPrice.value;
      }
      if (minArea.value != null && minArea.value! > 0) {
        queryParams["min_area"] = minArea.value;
      }
      if (maxArea.value != null && maxArea.value! < 10000) {
        queryParams["max_area"] = maxArea.value;
      }
      if (amenities.value.isNotEmpty) {
        queryParams["amenities[]"] = amenities.value;
      }
      if (listingCategory.value.isNotEmpty) {
        queryParams["listing_category"] = listingCategory.value;
      }
      if (propertyStatus.value.isNotEmpty) {
        queryParams["property_status"] = propertyStatus.value;
      }

      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.searchProperties,
          method: ApiMethod.get,
          queryParameters: queryParams,
        ),
      );
     
      final propertyResponse = PropertyResponse.fromJson(response.data);
      return Right(propertyResponse);
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }
}
