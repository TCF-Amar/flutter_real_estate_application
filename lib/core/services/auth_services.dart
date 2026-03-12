import 'package:dartz/dartz.dart';
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
import 'package:real_estate_app/features/auth/models/auth_data_model.dart';
import 'package:real_estate_app/features/auth/models/auth_response.dart';
import 'package:real_estate_app/features/auth/models/current_user_model.dart';
import 'package:real_estate_app/features/auth/models/sign_up_request_model.dart';
import 'package:real_estate_app/features/auth/models/sign_up_response_model.dart';

class AuthServices extends GetxService {
  final Logger log = Logger();
  final DioHelper _dioHelper = Get.find<DioHelper>();
  final TokenStorage _tokenStorage = Get.find<TokenStorage>();

  // ── Auth State ──────────────────────────────────────────────

  Future<void> checkAuthState() async {
    log.i('Checking auth state...');
    final token = await _tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      log.i('Token found → navigating to Main');
      Get.offAllNamed(AppRoutes.main);
    } else {
      log.i('No token → navigating to GetStarted');
      Get.offAllNamed(AppRoutes.getStart);
    }
  }

  // ── Login ───────────────────────────────────────────────────

  Future<Result<AuthResponse>> login(String email, String password) async {
    log.i('Login request for: $email');
    try {
      final response = await _dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.login,
          method: ApiMethod.post,
          body: {'email': email, 'password': password},
        ),
      );
      final authResponse = AuthResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      if (authResponse.data != null) {
        await _saveTokensFromAuthData(authResponse.data!);
        log.i('Login successful — tokens saved');
      }
      return Right(authResponse);
    } on AppException catch (e) {
      log.e('Login failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Login failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  // ── Sign Up ─────────────────────────────────────────────────

  Future<Result<SignUpResponseModel>> signUp(SignUpRequestModel model) async {
    log.i('Sign-up request for: ${model.email}');
    try {
      final response = await _dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.signUp,
          method: ApiMethod.post,
          body: model.toJson(),
        ),
      );
      log.d('Sign-up response: ${response.data}');
      final signUpResponse = SignUpResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      log.i('Sign-up successful');
      return Right(signUpResponse);
    } on AppException catch (e) {
      log.e('Sign-up failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Sign-up failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  // ── OTP Verification ───────────────────────────────────────

  Future<Result<AuthResponse>> verifyOtp(String email, String otp) async {
    log.i('Verify OTP for: $email');
    try {
      final response = await _dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.verifyOtp,
          method: ApiMethod.post,
          body: {'otp': otp, 'email': email},
        ),
      );
      final authResponse = AuthResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      if (authResponse.data != null) {
        await _saveTokensFromAuthData(authResponse.data!);
        log.i('OTP verified — tokens saved');
      }
      return Right(authResponse);
    } on AppException catch (e) {
      log.e('OTP verification failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('OTP verification failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  // ── Resend OTP ──────────────────────────────────────────────

  Future<Result<bool>> resendOtp(String email) async {
    log.i('Resend OTP to: $email');
    try {
      final res = await _dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.resendOtp,
          method: ApiMethod.post,
          body: {'email': email},
        ),
      );
      log.d('Resend OTP response: ${res.data}');
      log.i('OTP resent successfully');
      return const Right(true);
    } on AppException catch (e) {
      log.e('Resend OTP failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Resend OTP failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  // ── Buyer Onboarding ────────────────────────────────────────

  Future<Result<bool>> onboardBuyer(String country) async {
    log.i('Onboarding buyer — country: $country');
    try {
      final res = await _dioHelper.request(
        ApiRequest(
          url: ApiEndpoints.buyerOnboarding,
          method: ApiMethod.post,
          body: {'country': country},
        ),
      );
      log.d('Onboarding response: ${res.data}');
      log.i('Buyer onboarded successfully');
      return Right(true);
    } on AppException catch (e) {
      log.e('Onboarding failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Onboarding failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  // ── Current User ────────────────────────────────────────────

  FutureResult<CurrentUserModel> getCurrentUser() async {
    log.i('Fetching current user...');
    try {
      final response = await _dioHelper.request(
        ApiRequest(url: ApiEndpoints.currentUser, method: ApiMethod.get),
      );
      final user = CurrentUserModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      log.i('Current user fetched successfully');
      return Right(user);
    } on AppException catch (e) {
      log.e('Fetch current user failed (AppException): ${e.message}');
      return Left(ApiException.map(e));
    } catch (e) {
      log.e('Fetch current user failed (Unknown): $e');
      return Left(Failure(message: e.toString(), type: FailureType.unknown));
    }
  }

  // ── Logout ──────────────────────────────────────────────────

  Future<void> logout() async {
    log.i('Logging out — clearing tokens...');
    await _tokenStorage.deleteTokens();
    try {
      await _dioHelper.request(
        ApiRequest(url: ApiEndpoints.logout, method: ApiMethod.post),
      );
      log.i('Logout API called successfully');
    } catch (e) {
      log.w('Logout API call failed (non-critical): $e');
    }
  }

  // ── Token Helper ────────────────────────────────────────────

  Future<void> _saveTokensFromAuthData(AuthDataModel data) async {
    if (data.token.isEmpty) {
      log.w('Token is empty — skipping save');
      return;
    }
    await _tokenStorage.saveTokens(
      data.token,
      data.refreshToken,
      expiresAt: data.expiresAt.toIso8601String(),
    );
    log.d('Tokens saved (expires: ${data.expiresAt.toIso8601String()})');
  }
}
