import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/explore/models/agent_details_response_model.dart';
import 'package:real_estate_app/features/explore/models/agent_response_model.dart';
import 'package:real_estate_app/features/property/models/property_detail_response_model.dart';
import 'package:real_estate_app/features/property/models/property_filter.model.dart';
import 'package:real_estate_app/features/property/models/property_response_model.dart';
import 'package:real_estate_app/features/saved/models/saved_property.dart';
import 'package:real_estate_app/features/saved/models/saved_response.dart';
import 'package:real_estate_app/features/shared/models/review_response_model.dart';

class ExploreServices extends GetxService {
  final Logger log = Logger();
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
  final propertyType = "".obs;

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

  FutureResult<PropertyResponseModel> searchProperties() async {
    try {
      final queryParams = <String, dynamic>{
        "per_page": perPage.value,
        "page": page.value,
      };

      if (keywords.value.isNotEmpty) queryParams["search"] = keywords.value;
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
      if (propertyType.value.isNotEmpty) {
        queryParams["property_type"] = propertyType.value;
      }

      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.searchProperties,
          method: ApiMethod.get,
          queryParameters: queryParams,
        ),
      );
      log.d(queryParams);

      final propertyResponse = PropertyResponseModel.fromJson(response.data);
      return Right(propertyResponse);
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  FutureResult<SavedResponse> toggleFavorite({
    required String type,
    required int propertyId,
  }) async {
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.toggleFavorite,
          method: ApiMethod.post,
          body: {"type": type, "id": propertyId},
        ),
      );
      log.d(response.data);
      return Right(SavedResponse.fromJson(response.data));
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  FutureResult<List<SavedProperty>> getSavedProperties() async {
    try {
      final response = await dioHelper.request(
        ApiRequest(url: ApiEndpoints.getSavedProperties, method: ApiMethod.get),
      );
      return Right(
        response.data.map((x) => SavedProperty.fromJson(x)).toList(),
      );
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  FutureResult<PropertyDetailResponseModel> getPropertyDetails(int id) async {
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.getPropertyDetails(id),
          method: ApiMethod.get,
        ),
      );
      log.d(response.data);
      return Right(PropertyDetailResponseModel.fromJson(response.data));
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  FutureResult<ReviewResponse> getReviews(
    int id, {
    int page = 1,
    int perPage = 5,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        "per_page": perPage,
        "page": page,
      };
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.getPropertyReviews(id),
          method: ApiMethod.get,
          queryParameters: queryParameters,
        ),
      );
      log.d(response.data);
      return Right(ReviewResponse.fromJson(response.data));
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  //! =======================
  //? Agent services
  //! =======================

  FutureResult<AgentResponseMode> getAgents() async {
    try {
      final queryParameters = <String, dynamic>{};
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.agents,
          method: ApiMethod.get,
          queryParameters: queryParameters,
        ),
      );
      return Right(AgentResponseMode.fromJson(response.data!));
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  FutureResult<AgentDetailsResponse> getAgentDetails(int id) async {
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.getAgentDetails(id),
          method: ApiMethod.get,
        ),
      );
      log.d(response.data);
      return Right(AgentDetailsResponse.fromJson(response.data));
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }
}
