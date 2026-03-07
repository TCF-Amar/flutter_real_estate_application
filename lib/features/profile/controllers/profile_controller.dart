import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/profile_services.dart';
import 'package:real_estate_app/core/utils/image_picker_util.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/profile/models/basic_info_update_model.dart';
import 'package:real_estate_app/features/profile/views/widgets/image_preview.dart';
import 'package:real_estate_app/features/shared/models/user_model.dart';

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
  final _refreshing = false.obs;

  File? get image => _image.value;
  bool get isUploading => _isUploading.value;
  bool get isUpdating => _isUpdating.value;
  bool get refreshing => _refreshing.value;

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

  void initForEdit(UserModel user) {
    nameController.text = user.fullName ?? '';
    emailController.text = user.email ?? '';
    phoneController.text = user.phone ?? '';
  }

  Future<void> updateProfile() async {
    _isUpdating.value = true;

    await _updateUserData(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
    );

    _isUpdating.value = false;
    Get.back();
  }

  Future<void> _updateUserData({
    required String name,
    required String email,
    required String phone,
  }) async {
    final result = await _profileServices.updateBasicInfo(
      BasicInfoUpdateModel(fullName: name, email: email, phone: phone),
    );

    result.fold((failure) => log.e(failure.message), (data) {
      final current = _authController.user.value;
      if (current == null) return;
      _authController.user.value = current.copyWith(
        fullName: data.fullName,
        email: data.email,
        phone: data.phone,
      );
    });
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
