import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/services/auth_services.dart';
import 'package:real_estate_app/core/services/profile_services.dart';
import 'package:real_estate_app/core/utils/image_picker_util.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/profile/views/widgets/image_preview.dart';
import 'package:real_estate_app/features/profile/views/widgets/otp_dialog.dart';
import 'package:real_estate_app/features/shared/models/user_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_snackbar.dart';

class ProfileController extends GetxController {
  // ─── Dependencies ────────────────────────────────────────────────────────────

  final log = Logger();
  final _authController = Get.find<AuthController>();
  final _profileServices = Get.find<ProfileServices>();

  // ─── User ────────────────────────────────────────────────────────────────────

  Rxn<UserModel> get user => _authController.user;

  // ─── Text Controllers ────────────────────────────────────────────────────────

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // ─── State ───────────────────────────────────────────────────────────────────

  final _image = Rx<File?>(null);
  final _isUploading = false.obs;
  final _isUpdating = false.obs;
  final _isVerifyingEmail = false.obs;
  final _isVerifyingPhone = false.obs;
  final _refreshing = false.obs;
  Failure? get error => _authController.error;

  File? get image => _image.value;
  bool get isUploading => _isUploading.value;
  bool get isUpdating => _isUpdating.value;
  bool get isVerifyingEmail => _isVerifyingEmail.value;
  bool get isVerifyingPhone => _isVerifyingPhone.value;
  bool get refreshing => _refreshing.value;

  // ─── Avatar ──────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();

    // Listen to user changes
    ever(_authController.user, (UserModel? u) {
      if (u != null) {
        _checkEmailVerified(u);
        _checkPhoneVerified(u);
      }
    });

    emailController.addListener(() {
      final u = _authController.user.value;
      if (u != null) _checkEmailVerified(u);
    });

    phoneController.addListener(() {
      final u = _authController.user.value;
      if (u != null) _checkPhoneVerified(u);
    });
  }

  // ─── Avatar ──────────────────────────────────────────────────────────────────

  Future<void> selectImage(BuildContext context) async {
    final pickedImage = await ImagePickerUtil.pickImage(context);
    if (pickedImage == null) return;

    if (context.mounted) {
      final croppedImage = await showImagePreviewDialog(context, pickedImage);
      if (croppedImage != null) {
        _image.value = croppedImage;
        await _uploadProfileImage();
        Get.back();
      }
    }
  }

  Future<void> _uploadProfileImage() async {
    if (image == null) return;

    _isUploading.value = true;

    final result = await _profileServices.updateAvatar(image!);

    result.fold((failure) => log.e(failure.message), (url) async {
      _authController.user.value = _authController.user.value?.copyWith(
        profileImage: url,
      );
      if (await image!.exists()) {
        await image!.delete();
        log.d('Avatar temp file deleted');
      }
    });

    _isUploading.value = false;
  }

  // ─── Basic Info ──────────────────────────────────────────────────────────────

  final _isEmailVerifiedLocally = false.obs;
  final _isPhoneVerifiedLocally = false.obs;

  bool get isEmailVerified => _isEmailVerifiedLocally.value;
  bool get isPhoneVerified => _isPhoneVerifiedLocally.value;

  final _sessionVerifiedEmail = ''.obs;
  final _sessionVerifiedPhone = ''.obs;

  void _checkEmailVerified(UserModel u) {
    final currentText = emailController.text.trim();
    if (currentText == (u.email ?? '')) {
      _isEmailVerifiedLocally.value = u.emailVerified;
    } else if (currentText == _sessionVerifiedEmail.value &&
        currentText.isNotEmpty) {
      _isEmailVerifiedLocally.value = true;
    } else {
      _isEmailVerifiedLocally.value = false;
    }
  }

  void _checkPhoneVerified(UserModel u) {
    final currentText = phoneController.text.trim();
    if (currentText == (u.phone ?? '')) {
      _isPhoneVerifiedLocally.value = u.phoneVerified;
    } else if (currentText == _sessionVerifiedPhone.value &&
        currentText.isNotEmpty) {
      _isPhoneVerifiedLocally.value = true;
    } else {
      _isPhoneVerifiedLocally.value = false;
    }
  }

  void initForEdit(UserModel user) {
    nameController.text = user.fullName ?? '';
    emailController.text = user.email ?? '';
    phoneController.text = user.phone ?? '';

    _checkEmailVerified(user);
    _checkPhoneVerified(user);
  }

  Future<void> updateProfile() async {
    _isUpdating.value = true;

    await _updateUserData(
      name: nameController.text.trim(),
      // email: emailController.text.trim(),
      // phone: phoneController.text.trim(),
    );

    _isUpdating.value = false;
    Get.back();
  }

  Future<void> _updateUserData({required String name}) async {
    final result = await _profileServices.updateBasicInfo(name);

    result.fold((failure) => log.e(failure.message), (data) {
      final current = _authController.user.value;
      if (current == null) return;
      _authController.user.value = current.copyWith(fullName: data.fullName);
    });
  }

  // ─── Verify OTP Dialog ───────────────────────────────────────────────────────

  final _authServices = Get.find<AuthServices>();

  Future<void> verifyField(String fieldType) async {
    final targetValue = fieldType == 'email'
        ? emailController.text.trim()
        : phoneController.text.trim();

    if (targetValue.isEmpty) {
      AppSnackbar.error('Please enter a valid $fieldType');
      return;
    }

    final isVerifyingFlag = fieldType == 'email'
        ? _isVerifyingEmail
        : _isVerifyingPhone;
    isVerifyingFlag.value = true;
    final result = await _authServices.requestToUpdate(fieldType, targetValue);
    isVerifyingFlag.value = false;

    result.fold(
      (failure) {
        log.e(failure.message);
        AppSnackbar.error(failure.message);
      },
      (_) {
        // Success sending code, open BottomSheet or Dialog
        showOtpDialog(fieldType, targetValue);
      },
    );
  }

  void markFieldAsVerifiedLocally(String fieldType, String value) {
    if (fieldType == 'email') {
      _sessionVerifiedEmail.value = value;
      _checkEmailVerified(_authController.user.value!);
    } else {
      _sessionVerifiedPhone.value = value;
      _checkPhoneVerified(_authController.user.value!);
    }
  }

  // ─── Refresh ─────────────────────────────────────────────────────────────────
  Future<void> refreshProfile() async {
    _refreshing.value = true;
    await _authController.getCurrentUser();
    _refreshing.value = false;
  }

  // ─── Lifecycle ───────────────────────────────────────────────────────────────
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
