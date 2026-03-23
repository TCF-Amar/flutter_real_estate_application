import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/profile/models/maintenance_request_model.dart';

class MaintenanceServices {
  final Logger log = Logger();
  final dio = Get.find<DioHelper>();

  FutureResult<void> sendMaintenanceRequest({
    required String pid,
    required String title,
    required String category,
    required String description,
    required List<File> images,
    required List<File> videos,
  }) async {
    log.i('Send maintenance request...');
    try {
      final formData = FormData.fromMap({
        'property_id': pid,
        'title': title,
        'category': category,
        'description': description,
      });

      // Add images
      for (var image in images) {
        formData.files.add(
          MapEntry(
            'images[]',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }

      // Add videos
      for (var video in videos) {
        formData.files.add(
          MapEntry(
            'videos[]',
            await MultipartFile.fromFile(
              video.path,
              filename: video.path.split('/').last,
            ),
          ),
        );
      }

      final response = await dio.request(
        ApiRequest(
          url: ApiEndpoints.sendMaintenanceRequest,
          method: ApiMethod.post,
          body: formData,
        ),
      );
      log.d('Send maintenance request response: ${response.data}');
      log.i('Maintenance request sent successfully');
      return const Right(null);
    } on AppException catch (e) {
      log.e('Send maintenance request failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Send maintenance request failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  FutureResult<MaintenanceResponse> getMaintenanceRequests({
    int page = 1,
    int perPage = 10,
  }) async {
    log.i('Fetching maintenance requests (page: $page)...');
    try {
      final response = await dio.request(
        ApiRequest(
          url: ApiEndpoints.sendMaintenanceRequest,
          method: ApiMethod.get,
          queryParameters: {
            'page': page,
            'per_page': perPage,
          },
        ),
      );
      log.d('Fetch maintenance requests response: ${response.data}');
      final res = MaintenanceResponse.fromJson(response.data);
      log.i('Maintenance requests fetched successfully');
      return Right(res);
    } on AppException catch (e) {
      log.e('Fetch maintenance requests failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch maintenance requests failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  FutureResult<MaintenanceDetailResponse> getMaintenanceDetails(int id) async {
    log.i('Fetching maintenance details (id: $id)...');
    try {
      final response = await dio.request(
        ApiRequest(
          url: ApiEndpoints.getMaintenanceDetails(id),
          method: ApiMethod.get,
        ),
      );
      log.d('Fetch maintenance details response: ${response.data}');
      final res = MaintenanceDetailResponse.fromJson(response.data);
      log.i('Maintenance details fetched successfully');
      return Right(res);
    } on AppException catch (e) {
      log.e('Fetch maintenance details failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch maintenance details failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }
}
