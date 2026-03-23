import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/shared/models/user_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import '../widgets/profile_edit/index.dart';

class ProfileEdit extends StatelessWidget {
  final UserModel user;
  const ProfileEdit({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: const DefaultAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarSection(user: user, controller: controller),
            const SizedBox(height: 24),
            NameField(controller: controller),
            const SizedBox(height: 24),
            EmailField(controller: controller),
            const SizedBox(height: 24),
            PhoneField(controller: controller),
            const SizedBox(height: 24),
            SaveButton(controller: controller),
          ],
        ),
      ),
    );
  }
}
