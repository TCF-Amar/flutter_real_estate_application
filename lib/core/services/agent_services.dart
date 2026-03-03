import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/agent/models/agent_details_response_model.dart';
import 'package:real_estate_app/features/agent/models/agent_response_model.dart';
import 'package:real_estate_app/features/property/models/review_request_model.dart';
import 'package:real_estate_app/features/shared/models/review_response_model.dart';

class AgentServices extends GetxService {
  final Logger log = Logger();
  final DioHelper dioHelper = Get.find<DioHelper>();

  final location = "".obs;
  final city = "".obs;
  final roleType = "".obs;
  final minRating = "".obs;
  final experience = "".obs;
  final search = "".obs;
  final page = 1.obs;
  final limit = 10.obs;
  FutureResult<AgentResponseMode> getAgents() async {
    try {
      final queryParameters = <String, dynamic>{};
      if (location.value.isNotEmpty) {
        queryParameters['location'] = location.value;
      }
      if (city.value.isNotEmpty) {
        queryParameters['city'] = city.value;
      }
      if (roleType.value.isNotEmpty) {
        queryParameters['role_type'] = roleType.value;
      }
      if (minRating.value.isNotEmpty) {
        queryParameters['min_rating'] = minRating.value;
      }
      if (experience.value.isNotEmpty) {
        queryParameters['experience'] = experience.value;
      }
      if (search.value.isNotEmpty) {
        queryParameters['search'] = search.value;
      }
      if (page.value != 1) {
        queryParameters['page'] = page.value;
      }
      if (limit.value != 10) {
        queryParameters['per_page'] = limit.value;
      }
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

  FutureResult<AgentDetailModel> getAgentDetails(int id) async {
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.getAgentDetails(id),
          method: ApiMethod.get,
        ),
      );
      log.d("Agent details response status: ${response.data['status']}");
      return Right(AgentDetailModel.fromJson(response.data['data']));
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  FutureResult<ReviewResponse> getReviews(
    int id, {
    int page = 1,
    int perPage = 3,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        "per_page": perPage,
        "page": page,
      };
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.agentReviews(id),
          method: ApiMethod.get,
          queryParameters: queryParameters,
        ),
      );
      return Right(ReviewResponse.fromJson(response.data));
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  
  FutureResult<bool> addReview(
    int id,
    ReviewRequestModel reviewRequestModel,
  ) async {
    try {
      await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.agentReviews(id),
          method: ApiMethod.post,
          body: reviewRequestModel.toJson(),
        ),
      );
      return Right(true);
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }
}
