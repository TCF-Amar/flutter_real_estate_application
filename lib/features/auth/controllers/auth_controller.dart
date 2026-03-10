import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/core/services/auth_services.dart';
import 'package:real_estate_app/features/auth/models/current_user_model.dart';
import 'package:real_estate_app/features/auth/models/sign_up_request_model.dart';
import 'package:real_estate_app/features/shared/models/profile_model.dart';
import 'package:real_estate_app/features/shared/models/user_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_snackbar.dart';

class AuthController extends GetxController {
  final Logger log = Logger();
  final AuthServices _authServices = Get.find<AuthServices>();

  // ── State ─────────────────────────────────────────────────

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final Rxn<UserModel> user = Rxn<UserModel>();
  final Rxn<ProfileModel> userProfile = Rxn<ProfileModel>();
  final Rxn<CurrentUserModel> _currentUser = Rxn<CurrentUserModel>();
  CurrentUserModel? get currentUser => _currentUser.value;

  // final error = ''.obs;

  final Rxn<Failure?> _failure = Rxn<Failure?>();
  Failure? get error => _failure.value;

  @override
  void onClose() {
    // ── Sign-in controllers ────────────────────────────────
    signInEmailController.dispose();
    signInPasswordController.dispose();

    // ── Sign-up controllers ────────────────────────────────
    signUpFullNameController.dispose();
    signUpEmailController.dispose();
    signUpPhoneController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();

    for (final c in codeControllers) {
      c.dispose();
    }
    for (final n in codeFocusNodes) {
      n.dispose();
    }

    _resendTimer?.cancel();

    super.onClose();
  }

  Future<void> getCurrentUser() async {
    final result = await _authServices.getCurrentUser();
    result.fold(
      (failure) {
        log.e('Failed to fetch user: ${failure.message}');
        AppSnackbar.error(failure.message);
        _failure.value = failure;
      },
      (userData) {
        log.d(userData.data.user.fullName);
        user.value = userData.data.user;
        userProfile.value = userData.data.profile;
        _currentUser.value = userData;
      },
    );
  }

  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController =
      TextEditingController();

  void handleSignIn() async {
    FocusScope.of(Get.context!).unfocus();
    _isLoading.value = true;
    final result = await _authServices.login(
      signInEmailController.text.trim(),
      signInPasswordController.text,
    );
    result.fold(
      (failure) {
        _clearSignInFields();
        AppSnackbar.error(failure.message);
      },
      (response) {
        if (response.data?.token != null) {
          AppSnackbar.success('Login successful');
          log.d('Token: ${response.data?.token}');
          Get.offAllNamed(AppRoutes.main);
        } else {
          _clearSignInFields();
          AppSnackbar.error('Login failed. Please try again.');
        }
      },
    );
    _isLoading.value = false;
  }

  void _clearSignInFields() {
    signInEmailController.clear();
    signInPasswordController.clear();
  }

  // ── Sign Up ───────────────────────────────────────────────

  final TextEditingController signUpFullNameController =
      TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPhoneController = TextEditingController();
  final TextEditingController signUpPasswordController =
      TextEditingController();
  final TextEditingController signUpConfirmPasswordController =
      TextEditingController();

  void handleSignUp() async {
    FocusScope.of(Get.context!).unfocus();
    _isLoading.value = true;
    final result = await _authServices.signUp(
      SignUpRequestModel(
        fullName: signUpFullNameController.text,
        email: signUpEmailController.text.trim(),
        phone: signUpPhoneController.text.trim(),
        password: signUpPasswordController.text,
        passwordConfirmation: signUpConfirmPasswordController.text,
      ),
    );
    result.fold(
      (failure) {
        _clearSignUpFields();
        AppSnackbar.error(failure.message);
      },
      (response) {
        otpEmail.value = signUpEmailController.text.trim();
        AppSnackbar.success('Verification code sent to ${otpEmail.value}');
        Get.toNamed(AppRoutes.verifyCode, arguments: {'source': 'signup'});
      },
    );
    _isLoading.value = false;
  }

  void _clearSignUpFields() {
    signUpFullNameController.clear();
    signUpEmailController.clear();
    signUpPhoneController.clear();
    signUpPasswordController.clear();
    signUpConfirmPasswordController.clear();
  }

  // ── Forgot Password ───────────────────────────────────────

  void handleForgotPassword() async {
    FocusScope.of(Get.context!).unfocus();
    _isLoading.value = true;
    final email = signInEmailController.text.trim();
    if (email.isEmpty) {
      AppSnackbar.error('Please enter your email');
      _isLoading.value = false;
      return;
    }
    final result = await _authServices.resendOtp(email);
    result.fold((failure) => AppSnackbar.error(failure.message), (_) {
      otpEmail.value = email;
      AppSnackbar.success('Verification code sent to $email');
      Get.toNamed(AppRoutes.verifyCode, arguments: {'source': 'forgot'});
    });
    _isLoading.value = false;
  }

  void logout() async {
    _isLoading.value = true;
    await _authServices.logout();
    Get.offAllNamed(AppRoutes.signin);
    _isLoading.value = false;
  }

  // ── OTP / Verify Code ─────────────────────────────────────

  final RxString otpEmail = ''.obs;

  final List<TextEditingController> codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> codeFocusNodes = List.generate(6, (_) => FocusNode());

  final RxInt resendCountdown = 60.obs;
  final RxBool canResend = false.obs;
  final RxString verifySource = ''.obs;
  Timer? _resendTimer;

  void initVerifyCode(String? source) {
    verifySource.value = source ?? '';
    startCountdown();
    codeFocusNodes[0].requestFocus();
  }

  void disposeVerifyCode() {
    _resendTimer?.cancel();
    for (final c in codeControllers) {
      c.clear();
    }
  }

  void startCountdown() {
    canResend.value = false;
    resendCountdown.value = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void onCodeChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        codeFocusNodes[index + 1].requestFocus();
      } else {
        codeFocusNodes[index].unfocus();
        handleVerify();
      }
    } else if (value.isEmpty && index > 0) {
      codeFocusNodes[index - 1].requestFocus();
    }
  }

  String get verificationCode => codeControllers.map((c) => c.text).join();

  void handleVerify() async {
    FocusScope.of(Get.context!).unfocus();
    _isLoading.value = true;
    if (verificationCode.length == 6) {
      final result = await _authServices.verifyOtp(
        otpEmail.value,
        verificationCode,
      );
      result.fold(
        (failure) {
          _clearOtpFields();
          AppSnackbar.error(failure.message);
        },
        (response) {
          AppSnackbar.success('Email verified successfully');
          if (verifySource.value == 'signup') {
            Get.offAllNamed(AppRoutes.selectCountry);
          } else {
            Get.toNamed(AppRoutes.resetPassword);
          }
        },
      );
    } else {
      _clearOtpFields();
      AppSnackbar.error('Please enter the complete 6-digit code');
    }
    _isLoading.value = false;
  }

  void _clearOtpFields() {
    for (final c in codeControllers) {
      c.clear();
    }
    codeFocusNodes[0].requestFocus();
  }

  void handleResendCode() async {
    if (!canResend.value) return;
    _isLoading.value = true;
    final result = await _authServices.resendOtp(otpEmail.value);
    result.fold((failure) => AppSnackbar.error(failure.message), (_) {
      AppSnackbar.info(
        'A new code was sent to ${otpEmail.value}',
        title: 'Code Sent',
      );
      _clearOtpFields();
      startCountdown();
    });
    _isLoading.value = false;
  }

  Future<void> handlePaste() async {
    final clipboardData = await Clipboard.getData('text/plain');
    final pastedText = clipboardData?.text ?? '';
    if (pastedText.length == 6 && RegExp(r'^\d+$').hasMatch(pastedText)) {
      for (int i = 0; i < 6; i++) {
        codeControllers[i].text = pastedText[i];
      }
      codeFocusNodes[5].unfocus();
      handleVerify();
    } else {
      AppSnackbar.error(
        'Please paste a valid 6-digit code',
        title: 'Invalid Code',
      );
    }
  }

  // ── Select Country ────────────────────────────────────────

  final RxString selectedCountry = ''.obs;

  final List<Map<String, String>> countries = [
    {'name': 'United Arab Emirates', 'flag': '🇦🇪'},
    {'name': 'Singapore', 'flag': '🇸🇬'},
    {'name': 'United States', 'flag': '🇺🇸'},
    {'name': 'United Kingdom', 'flag': '🇬🇧'},
  ];

  void selectCountry(String name) => selectedCountry.value = name;

  void handleContinue() async {
    if (selectedCountry.value.isEmpty) {
      AppSnackbar.error('Please select a country');
      return;
    }
    _isLoading.value = true;
    final result = await _authServices.onboardBuyer(selectedCountry.value);
    result.fold((failure) => AppSnackbar.error(failure.message), (_) {
      AppSnackbar.success('Country selected: ${selectedCountry.value}');
      Get.offAllNamed(AppRoutes.main);
    });
    _isLoading.value = false;
  }

  // delete account

  void handleDeleteAccount({
    required String password,
    required String confirmation,
  }) async {
    _isLoading.value = true;
    final result = await _authServices.deleteAccount(password, confirmation);
    result.fold((failure) => AppSnackbar.error(failure.message), (_) {
      AppSnackbar.success('Account deleted successfully');
      logout();
    });
    _isLoading.value = false;
  }
}
