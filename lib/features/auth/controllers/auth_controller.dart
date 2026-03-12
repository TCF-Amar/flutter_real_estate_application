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

  final Rxn<Failure> _error = Rxn<Failure>();
  Failure? get error => _error.value;
  void setError(Failure failure) {
    _error.value = failure;
  }

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
    log.i('Fetching current user...');
    final result = await _authServices.getCurrentUser();
    result.fold(
      (failure) {
        log.e('Failed to fetch user: ${failure.message}');
        _error.value = failure;
      },
      (userData) {
        log.d('User fetched: ${userData.data.user.toJson()}');
        log.d('Onboarding completed: ${userData.data.onboarding.completed}');
        user.value = userData.data.user;
        userProfile.value = userData.data.profile;
        _currentUser.value = userData;

        if (!userData.data.onboarding.completed) {
          log.i('Onboarding incomplete → navigating to SelectCountry');
          Get.offAllNamed(AppRoutes.selectCountry);
        }
      },
    );
  }

  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController =
      TextEditingController();

  void handleSignIn() async {
    FocusScope.of(Get.context!).unfocus();
    _isLoading.value = true;
    log.i('Sign-in attempt for: ${signInEmailController.text.trim()}');
    final result = await _authServices.login(
      signInEmailController.text.trim(),
      signInPasswordController.text,
    );
    result.fold(
      (failure) {
        log.e('Sign-in failed: ${failure.message}');
        _clearSignInFields();
        AppSnackbar.error(failure.message);
      },
      (response) {
        if (response.data?.token != null) {
          log.i('Sign-in successful');
          log.d('Token: ${response.data?.token}');
          AppSnackbar.success('Login successful');

          if (response.data?.onboardingCompleted == true) {
            log.i('Onboarding complete → navigating to Main');
            Get.offAllNamed(AppRoutes.main);
          } else {
            log.i('Onboarding incomplete → navigating to SelectCountry');
            Get.offAllNamed(AppRoutes.selectCountry);
          }
        } else {
          log.w('Sign-in response missing token');
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
    log.i('Sign-up attempt for: ${signUpEmailController.text.trim()}');
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
        log.e('Sign-up failed: ${failure.message}');
        _clearSignUpFields();
        AppSnackbar.error(failure.message);
      },
      (response) {
        log.i('Sign-up successful → navigating to VerifyCode');
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
      log.w('Forgot password: email field is empty');
      AppSnackbar.error('Please enter your email');
      _isLoading.value = false;
      return;
    }
    log.i('Forgot password request for: $email');
    final result = await _authServices.resendOtp(email);
    result.fold((failure) {
      log.e('Forgot password failed: ${failure.message}');
      AppSnackbar.error(failure.message);
    }, (_) {
      log.i('OTP sent → navigating to VerifyCode');
      otpEmail.value = email;
      AppSnackbar.success('Verification code sent to $email');
      Get.toNamed(AppRoutes.verifyCode, arguments: {'source': 'forgot'});
    });
    _isLoading.value = false;
  }

  void logout() async {
    log.i('Logging out...');
    _isLoading.value = true;
    await _authServices.logout();
    log.i('Logged out → navigating to SignIn');
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
      log.i('Verifying OTP for: ${otpEmail.value}');
      final result = await _authServices.verifyOtp(
        otpEmail.value,
        verificationCode,
      );
      result.fold(
        (failure) {
          log.e('OTP verification failed: ${failure.message}');
          _clearOtpFields();
          AppSnackbar.error(failure.message);
        },
        (response) {
          log.i('OTP verified successfully (source: ${verifySource.value})');
          AppSnackbar.success('Email verified successfully');
          if (verifySource.value == 'signup') {
            if (response.data?.onboardingCompleted == true) {
              log.i('Onboarding complete → navigating to Main');
              Get.offAllNamed(AppRoutes.main);
            } else {
              log.i('Onboarding incomplete → navigating to SelectCountry');
              Get.offAllNamed(AppRoutes.selectCountry);
            }
          } else {
            log.i('Forgot password flow → navigating to ResetPassword');
            Get.toNamed(AppRoutes.resetPassword);
          }
        },
      );
    } else {
      log.w('OTP incomplete: ${verificationCode.length}/6 digits entered');
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
    log.i('Resending OTP to: ${otpEmail.value}');
    final result = await _authServices.resendOtp(otpEmail.value);
    result.fold((failure) {
      log.e('Resend OTP failed: ${failure.message}');
      AppSnackbar.error(failure.message);
    }, (_) {
      log.i('OTP resent successfully');
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
      log.w('handleContinue: no country selected');
      AppSnackbar.error('Please select a country');
      return;
    }
    _isLoading.value = true;
    log.i('Onboarding with country: ${selectedCountry.value}');
    final result = await _authServices.onboardBuyer(selectedCountry.value);
    result.fold((failure) {
      log.e('Onboarding failed: ${failure.message}');
      AppSnackbar.error(failure.message);
    }, (_) {
      log.i('Onboarding complete → navigating to Main');
      AppSnackbar.success('Country selected: ${selectedCountry.value}');
      Get.offAllNamed(AppRoutes.main);
    });
    _isLoading.value = false;
  }
}
