import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SaveButton extends StatelessWidget {
  final ProfileController controller;
  const SaveButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          AppButton(
            text: 'Save',
            isLoading: controller.isUpdating,
            onPressed: controller.updateProfile,
          ),
        ],
      ),
    );
  }
}
