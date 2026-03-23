import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/favorite/models/favorite_response_model.dart';
import 'package:real_estate_app/features/property/models/property_detail_response_model.dart';
import 'package:real_estate_app/features/property/models/property_filter.model.dart';
import 'package:real_estate_app/features/property/models/property_inquiry_req_model.dart';
import 'package:real_estate_app/features/property/models/property_response_model.dart';
import 'package:real_estate_app/features/property/models/review_request_model.dart';
import 'package:real_estate_app/features/favorite/models/saved_response.dart';
import 'package:real_estate_app/features/shared/models/property_search_params.dart';
import 'package:real_estate_app/features/shared/models/review_response_model.dart';

class PropertyServices extends GetxService {
  final Logger log = Logger();
  final DioHelper dioHelper = Get.find<DioHelper>();

  // ── Filter State ────────────────────────────────────────────

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
  final perPage = 10.obs;
  final page = 1.obs;
  final propertyType = "".obs;

  // ── Filter Data ─────────────────────────────────────────────

  FutureResult<PropertyFilterModel> getFilterData() async {
    log.i('Fetching property filter data...');
    try {
      final response = await dioHelper.request(
        ApiRequest(url: ApiEndpoints.filterData, method: ApiMethod.get),
      );
      log.i('Filter data fetched successfully');
      return Right(PropertyFilterModel.fromJson(response.data));
    } on AppException catch (e) {
      log.e('Fetch filter data failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch filter data failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Search Properties ───────────────────────────────────────

  FutureResult<PropertyResponseModel> searchProperties({
    PropertySearchParams? params,
  }) async {
    final effectiveParams =
        params ??
        PropertySearchParams(
          city: city.value,
          propertyCategory: propertyCategory,
          bhk: bhk.toList(),
          minPrice: minPrice.value,
          maxPrice: maxPrice.value,
          minArea: minArea.value,
          maxArea: maxArea.value,
          amenities: amenities.value,
          listingCategory: listingCategory.value,
          keywords: keywords.value,
          propertyStatus: propertyStatus.value,
          propertyType: propertyType.value,
          perPage: perPage.value,
          page: page.value,
        );

    log.i('Searching properties (page: ${effectiveParams.page})...');
    try {
      final queryParams = effectiveParams.toJson();

      log.d('Search filters: $queryParams');
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.searchProperties,
          method: ApiMethod.get,
          queryParameters: queryParams,
        ),
      );

      final propertyResponse = PropertyResponseModel.fromJson(response.data);
      log.i(
        'Properties search returned ${propertyResponse.data.length} results',
      );
      return Right(propertyResponse);
    } on AppException catch (e) {
      log.e('Search properties failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Search properties failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Toggle Favorite ─────────────────────────────────────────

  FutureResult<SavedResponse> toggleFavoriteProperty({
    required String type,
    required int propertyId,
  }) async {
    log.i('Toggle favorite — type: $type, propertyId: $propertyId');
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.toggleFavoriteProperty,
          method: ApiMethod.post,
          body: {"type": type, "id": propertyId},
        ),
      );
      log.d('Toggle favorite response: ${response.data}');
      log.i('Favorite toggled successfully');
      return Right(SavedResponse.fromJson(response.data));
    } on AppException catch (e) {
      log.e('Toggle favorite failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Toggle favorite failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Saved Properties ────────────────────────────────────────

  FutureResult<FavoriteResponseModel> getSavedProperties() async {
    log.i('Fetching saved properties...');
    try {
      final response = await dioHelper.request(
        ApiRequest(url: ApiEndpoints.getSavedProperties, method: ApiMethod.get),
      );
      log.i('Saved properties fetched successfully');
      return Right(FavoriteResponseModel.fromJson(response.data));
    } on AppException catch (e) {
      log.e('Fetch saved properties failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch saved properties failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Property Details ────────────────────────────────────────

  FutureResult<PropertyDetailResponseModel> getPropertyDetails(int id) async {
    log.i('Fetching property details for id: $id');
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.getPropertyDetails(id),
          method: ApiMethod.get,
        ),
      );
      log.i('Property details fetched successfully');
      return Right(PropertyDetailResponseModel.fromJson(response.data));
    } on AppException catch (e) {
      log.e('Fetch property details failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch property details failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Property Reviews ────────────────────────────────────────

  FutureResult<ReviewResponse> getReviews(
    int id, {
    int page = 1,
    int perPage = 3,
  }) async {
    log.i('Fetching reviews for property: $id (page: $page)');
    try {
      final queryParameters = <String, dynamic>{
        "per_page": perPage,
        "page": page,
      };
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.propertyReviews(id),
          method: ApiMethod.get,
          queryParameters: queryParameters,
        ),
      );
      log.i('Property reviews fetched successfully');
      return Right(ReviewResponse.fromJson(response.data));
    } on AppException catch (e) {
      log.e('Fetch property reviews failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch property reviews failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Add Review ──────────────────────────────────────────────

  FutureResult<bool> addReview(
    int id,
    ReviewRequestModel reviewRequestModel,
  ) async {
    log.i('Adding review for property: $id');
    try {
      await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.propertyReviews(id),
          method: ApiMethod.post,
          body: reviewRequestModel.toJson(),
        ),
      );
      log.i('Property review added successfully');
      return Right(true);
    } on AppException catch (e) {
      log.e('Add property review failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Add property review failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Similar Properties ──────────────────────────────────────

  FutureResult<PropertyResponseModel> getSimilarProperties(int id) async {
    log.i('Fetching similar properties for id: $id');
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.similarProperties(id),
          method: ApiMethod.get,
        ),
      );
      log.i('Similar properties fetched successfully');
      return Right(PropertyResponseModel.fromJson(response.data));
    } on AppException catch (e) {
      log.e('Fetch similar properties failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch similar properties failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  FutureResult<bool> addInquiry(PropertyInquiryReqModel reqModel) async {
    log.i('Adding enquiry for property: ${reqModel.pId}');
    try {
      await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.propertyInquiry(reqModel.pId),
          method: ApiMethod.post,
          body: reqModel.toJson(),
        ),
      );
      log.i('Property enquiry added successfully');
      return Right(true);
    } on AppException catch (e) {
      log.e('Add property enquiry failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Add property review failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }
}
