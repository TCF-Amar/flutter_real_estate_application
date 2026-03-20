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
import 'package:real_estate_app/features/profile/models/basic_info_update_model.dart';

class ProfileServices {
  final Logger log = Logger();
  final dio = Get.find<DioHelper>();

  // ── Update Avatar ───────────────────────────────────────────

  FutureResult<String?> updateAvatar(File image) async {
    log.i('Uploading avatar: ${image.path.split('/').last}');
    try {
      final formData = FormData.fromMap({
        "profile_image": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final response = await dio.request(
        ApiRequest(
          url: ApiEndpoints.uploadAvatar,
          method: ApiMethod.post,
          body: formData,
        ),
      );

      final profileUrl = response.data['data']["profile_url"];
      log.i('Avatar uploaded successfully');
      log.d('Profile URL: $profileUrl');
      return Right(profileUrl);
    } on AppException catch (e) {
      log.e('Upload avatar failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Upload avatar failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Update Basic Info ───────────────────────────────────────

  FutureResult<BasicInfoUpdateModel> updateBasicInfo(String name) async {
    log.i('Updating basic info — name: $name');
    final data = {if (name.isNotEmpty) 'full_name': name};
    try {
      final res = await dio.request(
        ApiRequest(
          url: ApiEndpoints.updateBasicInfo,
          method: ApiMethod.put,
          body: data,
        ),
      );
      log.d('Update basic info response: ${res.data}');
      final response = res.data["data"] as Map<String, dynamic>;
      log.i('Basic info updated successfully');
      return Right(BasicInfoUpdateModel.fromJson(response));
    } on AppException catch (e) {
      log.e('Update basic info failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Update basic info failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  // ── Delete Account ──────────────────────────────────────────

  FutureResult<void> deleteAccount(String password, String confirmation) async {
    log.i('Delete account request...');
    try {
      await dio.request(
        ApiRequest(
          url: ApiEndpoints.deleteAccount,
          method: ApiMethod.delete,
          body: {'password': password, 'confirmation': confirmation},
        ),
      );
      log.i('Account deleted successfully');
      return const Right(null);
    } on AppException catch (e) {
      log.e('Delete account failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Delete account failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  // ── Request to Update (Send OTP) ────────────────────────────

  FutureResult<bool> requestToUpdate(String fieldType, String value) async {
    log.i('Request to update — type: $fieldType, value: $value');
    try {
      final res = await dio.request(
        ApiRequest(
          url: ApiEndpoints.requestToUpdate,
          method: ApiMethod.post,
          body: {'type': fieldType, 'value': value},
        ),
      );
      log.d('Request to update response: ${res.data}');
      log.i('OTP sent successfully for $fieldType update');
      return const Right(true);
    } on AppException catch (e) {
      log.e('Request to update failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Request to update failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  // ── Verify Change OTP ───────────────────────────────────────

  FutureResult<bool> verifyChangeOtp(
    String fieldType,
    String value,
    String otp,
  ) async {
    log.i('Verify change OTP — type: $fieldType');
    try {
      final res = await dio.request(
        ApiRequest(
          url: ApiEndpoints.verifyChangeOtp,
          method: ApiMethod.post,
          body: {'type': fieldType, 'value': value, 'otp': otp},
        ),
      );
      log.d('Verify change OTP response: ${res.data}');
      log.i('OTP verified successfully for $fieldType');
      return const Right(true);
    } on AppException catch (e) {
      log.e('Verify change OTP failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Verify change OTP failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  // ── Change Password ─────────────────────────────────────────

  FutureResult<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    log.i('Change password request...');
    try {
      final res = await dio.request(
        ApiRequest(
          url: ApiEndpoints.changePassword,
          method: ApiMethod.put,
          body: {
            'current_password': currentPassword,
            'password': newPassword,
            'password_confirmation': confirmPassword,
          },
        ),
      );
      log.d('Change password response: ${res.data}');
      log.i('Password changed successfully');
      return const Right(true);
    } on AppException catch (e) {
      log.e('Change password failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Change password failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  FutureResult<void> updateCountry(String? country) async {
    try {
      final response = await dio.request(
        ApiRequest(
          url: ApiEndpoints.updateSettings,
          method: ApiMethod.post,
          contentType: 'application/',
          body: {'country': country},
        ),
      );
      log.d('Update country response: ${response.data}');
      log.i('Country updated successfully');
      return const Right(null);
    } on AppException catch (e) {
      log.e('Update country failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Update country failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }
}
