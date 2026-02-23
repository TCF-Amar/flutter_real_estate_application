import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/core/storage/token_storage.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/auth/models/auth_response.dart';
import 'package:real_estate_app/features/auth/models/current_user_model.dart';
import 'package:real_estate_app/features/auth/models/sign_up_request_model.dart';
import 'package:real_estate_app/features/auth/models/sign_up_response_model.dart';

class AuthServices extends GetxService {
  final Logger log = Logger();
  final DioHelper _dioHelper = Get.find<DioHelper>();
  final TokenStorage _tokenStorage = Get.find<TokenStorage>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuth());
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 3));
    final token = await _tokenStorage.getToken();
    if (token != null) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.offAllNamed(AppRoutes.getStart);
    }
  }

  // set token
  void setToken(String token) async {
    await _tokenStorage.saveTokens(token, '');
  }

  Future<Result<AuthResponse>> login(String email, String password) async {
    try {
      final response = await _dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.login,
          method: ApiMethod.post,
          body: {'email': email, 'password': password},
        ),
      );
      final authResponse = AuthResponse.fromJson(response.data);
      if (authResponse.data?.token != null) {
        await _tokenStorage.saveTokens(
          authResponse.data!.token,
          authResponse.data!.refreshToken,
          expiresAt: authResponse.data!.expiresAt.toIso8601String(),
        );
      }
      return Right(authResponse);
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  Future<Result<SignUpResponseModel>> signUp(SignUpRequestModel model) async {
    try {
      final response = await _dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.signUp,
          method: ApiMethod.post,
          body: model.toJson(),
        ),
      );
      log.d(response.data);
      final signUpResponse = SignUpResponseModel.fromJson(response.data);
      return Right(signUpResponse);
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  Future<Result<AuthResponse>> verifyOtp(String email, String otp) async {
    try {
      final response = await _dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.verifyOtp,
          method: ApiMethod.post,
          body: {'otp': otp, 'email': email},
        ),
      );
      final authResponse = AuthResponse.fromJson(response.data);
      if (authResponse.data?.token != null) {
        await _tokenStorage.saveTokens(
          authResponse.data!.token,
          authResponse.data!.refreshToken,
          expiresAt: authResponse.data!.expiresAt.toIso8601String(),
        );
      }
      return Right(authResponse);
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  Future<Result<bool>> resendOtp(String email) async {
    try {
      final res = await _dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.resendOtp,
          method: ApiMethod.post,
          body: {'email': email},
        ),
      );
      log.d(res.data);
      return const Right(true);
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  // change country
  Future<Result<bool>> onboardBuyer(String country) async {
    try {
      await _dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.buyerOnboarding,
          method: ApiMethod.post,
          body: {'country': country},
        ),
      );
      return const Right(true);
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  FutureResult<CurrentUserModel> getCurrentUser() async {
    try {
      final response = await _dioHelper.request(
        ApiRequest(url: ApiEndpoints.currentUser, method: ApiMethod.get),
      );
      final user = CurrentUserModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Right(user);
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  Future<void> logout() async {
    // Always clear the local token first so the user is logged out immediately
    await _tokenStorage.deleteTokens();
    // Fire the server-side logout silently — ignore errors
    try {
      await _dioHelper.request(
        ApiRequest(url: ApiEndpoints.logout, method: ApiMethod.post),
      );
    } catch (_) {}
  }
}
