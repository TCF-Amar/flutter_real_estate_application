import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class PropertyInquiry extends StatelessWidget {
  const PropertyInquiry({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyDetailsController>();
    final contact = controller.propertyDetail?.contact;
    final formKey = GlobalKey<FormState>();
    return AppContainer(
      margin: const EdgeInsets.only(top: 25, bottom: 25),

      showShadow: true,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: AppImage(
                      path: contact?.profileImage,
                      radius: BorderRadius.circular(50),
                      errorIcon: Icons.person,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      AppText(
                        contact?.name ?? "No Name",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      AppText(
                        contact?.company ?? "No Company",
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: controller.nameController,
                hintText: "Name",
                showBorder: true,
                borderColor: AppColors.grey.withValues(alpha: 0.2),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: controller.phoneController,
                hintText: "Phone",
                keyboardType: TextInputType.phone,
                showBorder: true,
                borderColor: AppColors.grey.withValues(alpha: 0.2),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: controller.emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                showBorder: true,
                borderColor: AppColors.grey.withValues(alpha: 0.2),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: controller.messageController,
                hintText: "Message(optional)",
                keyboardType: TextInputType.text,
                maxLines: 5,
                showBorder: true,
                borderColor: AppColors.grey.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 16),
              Obx(
                () => AppButton(
                  text: "Send Message",
                  isLoading: controller.isLoadingInquiry,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.addInquiry();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
