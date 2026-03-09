import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ContactMessage extends StatelessWidget {
  const ContactMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyDetailsController>();
    final contact = controller.propertyDetail?.contact;
    return AppContainer(
      margin: const EdgeInsets.only(top: 25, bottom: 25),
      // height: 300,
      // decoration: BoxDecoration(
      //   color: AppColors.white,
      //   borderRadius: BorderRadius.circular(12),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withValues(alpha: 0.09),
      //       blurRadius: 5,
      //       offset: const Offset(0, 2),
      //     ),
      //   ],
      // ),
      showShadow: true,
      child: Form(
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
                controller: TextEditingController(),
                hintText: "Name",
                border: true,
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
                controller: TextEditingController(),
                hintText: "Phone",
                keyboardType: TextInputType.phone,
                border: true,
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
                controller: TextEditingController(),
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                border: true,
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
                controller: TextEditingController(),
                hintText: "Message",
                keyboardType: TextInputType.text,
                maxLines: 5,
                border: true,
                borderColor: AppColors.grey.withValues(alpha: 0.2),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              AppContainer(
                child: DropdownButtonHideUnderline(
                  child: DropdownFlutter(
                    items: ["1", "2", "3", "4", "5"],
                    onChanged: (value) {},
                    hintText: "Select",
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppButton(text: "Send Message", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
