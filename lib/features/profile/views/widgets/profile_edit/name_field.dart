import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class NameField extends StatelessWidget {
  final ProfileController controller;
  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText('Full Name'),
        const SizedBox(height: 10),
        AppTextFormField(
          hintText: 'Enter full name',
          controller: controller.nameController,
          showBorder: true,
          borderWidth: 2,
          borderSideType: BorderSideType.bottom,
          fontSize: 14,
          borderRadius: BorderRadius.zero,
          keyboardType: TextInputType.name,
          prefixIcon: AppSvg(path: Assets.icons.person, width: 12, height: 12),
        ),
      ],
    );
  }
}
