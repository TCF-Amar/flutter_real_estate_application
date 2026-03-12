import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';
import 'package:real_estate_app/features/agent/models/agent_details_response_model.dart';
import 'package:real_estate_app/features/agent/models/agent_response_model.dart';
import 'package:real_estate_app/features/favorite/models/favorite_response_model.dart';
import 'package:real_estate_app/features/property/models/review_request_model.dart';
import 'package:real_estate_app/features/shared/models/review_response_model.dart';

class AgentServices extends GetxService {
  final Logger log = Logger();
  final DioHelper dioHelper = Get.find<DioHelper>();

  // ── Filter State ────────────────────────────────────────────

  final location = "".obs;
  final city = "".obs;
  final roleType = "".obs;
  final minRating = "".obs;
  final experience = "".obs;
  final search = "".obs;
  final page = 1.obs;
  final limit = 10.obs;

  // ── Get Agents ──────────────────────────────────────────────

  FutureResult<AgentResponseMode> getAgents() async {
    log.i('Fetching agents...');
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

      log.d('Agent filters: $queryParameters');
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.agents,
          method: ApiMethod.get,
          queryParameters: queryParameters,
        ),
      );
      log.i('Agents fetched successfully');
      return Right(AgentResponseMode.fromJson(response.data!));
    } on AppException catch (e) {
      log.e('Fetch agents failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch agents failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Agent Details ───────────────────────────────────────────

  FutureResult<AgentDetailModel> getAgentDetails(int id) async {
    log.i('Fetching agent details for id: $id');
    try {
      final response = await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.getAgentDetails(id),
          method: ApiMethod.get,
        ),
      );
      log.d('Agent details status: ${response.data['status']}');
      log.i('Agent details fetched successfully');
      return Right(AgentDetailModel.fromJson(response.data['data']));
    } on AppException catch (e) {
      log.e('Fetch agent details failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch agent details failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Agent Reviews ───────────────────────────────────────────

  FutureResult<ReviewResponse> getReviews(
    int id, {
    int page = 1,
    int perPage = 3,
  }) async {
    log.i('Fetching reviews for agent: $id (page: $page)');
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
      log.i('Agent reviews fetched successfully');
      return Right(ReviewResponse.fromJson(response.data));
    } on AppException catch (e) {
      log.e('Fetch agent reviews failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch agent reviews failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Add Review ──────────────────────────────────────────────

  FutureResult<bool> addReview(
    int id,
    ReviewRequestModel reviewRequestModel,
  ) async {
    log.i('Adding review for agent: $id');
    try {
      await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.agentReviews(id),
          method: ApiMethod.post,
          body: reviewRequestModel.toJson(),
        ),
      );
      log.i('Review added successfully');
      return Right(true);
    } on AppException catch (e) {
      log.e('Add review failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Add review failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Send Enquiry ────────────────────────────────────────────

  Future<bool?> sendAgentEnquiry(
    int id,
    EnquiryRequestModel enquiryRequestModel,
  ) async {
    log.i('Sending enquiry to agent: $id');
    try {
      await dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.sendAgentEnquiry(id),
          method: ApiMethod.post,
          body: enquiryRequestModel.toMap(),
        ),
      );
      log.i('Enquiry sent successfully');
      return true;
    } on AppException catch (e) {
      log.e('Send enquiry failed: ${e.message}');
      return false;
    }
  }

  // ── Saved Agents ────────────────────────────────────────────

  FutureResult<FavoriteResponseModel> getSavedAgents() async {
    log.i('Fetching saved agents...');
    try {
      final response = await dioHelper.request(
        ApiRequest(url: ApiEndpoints.getSavedAgents, method: ApiMethod.get),
      );
      log.i('Saved agents fetched successfully');
      return Right(FavoriteResponseModel.fromJson(response.data));
    } on AppException catch (e) {
      log.e('Fetch saved agents failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch saved agents failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }
}
