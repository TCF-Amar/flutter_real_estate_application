import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ADContactForm extends StatefulWidget {
  const ADContactForm({super.key});

  @override
  State<ADContactForm> createState() => _ADContactFormState();
}

class _ADContactFormState extends State<ADContactForm> {
  late final GlobalKey<FormState> formKey;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController messageController;

  final Map<String, String> _items = {
    "Select": "",
    "For sale": "for_sale",
    "For rent": "for_rent",
  };

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AgentDetailsController>();
    final agent = controller.agentDetails;
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.09),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                "Contact ${agent?.name}",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 10),
              AppTextFormField(
                controller: TextEditingController(),
                hintText: "Name",
                showContainerBorder: true,
                containerBorderColor: AppColors.grey.withValues(alpha: 0.2),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              AppTextFormField(
                controller: TextEditingController(),
                hintText: "Phone",
                showContainerBorder: true,
                containerBorderColor: AppColors.grey.withValues(alpha: 0.2),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a phone number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              AppTextFormField(
                controller: TextEditingController(),
                hintText: "email",
                showContainerBorder: true,
                containerBorderColor: AppColors.grey.withValues(alpha: 0.2),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a emailAddress";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              AppTextFormField(
                controller: TextEditingController(),
                hintText: "Message",
                keyboardType: TextInputType.text,
                maxLines: 5,
                showContainerBorder: true,
                containerBorderColor: AppColors.grey.withValues(alpha: 0.2),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 14),
              DropdownFlutter(
                items: _items.entries.map((e) => e.key).toList(),

                onChanged: (String? value) {},
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  AppText("By submitting the form I agree ", fontSize: 14),
                  AppText(
                    "Term of use",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ],
              ),
              SizedBox(height: 14),
              AppButton(
                text: "Send Message",
                isLoading: controller.isSendingEnquiry,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final isSent = await controller.sendEnquiry(
                      name: nameController.text.trim(),
                      phone: phoneController.text.trim(),
                      email: emailController.text.trim(),
                      message: messageController.text.trim(),
                    );
                    if (isSent) {
                      AppSnackbar.success("Message sent successfully");
                      nameController.clear();
                      phoneController.clear();
                      emailController.clear();
                      messageController.clear();

                      // Get.back();
                    }
                  }
                },
              ),

              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: "WhatsApp",
                      icon: AppSvg(
                        path: Assets.icons.whatsappOutline,
                        color: AppColors.grey,
                      ),
                      onPressed: () {},
                      textColor: AppColors.grey,
                      borderColor: AppColors.grey.withValues(alpha: 0.2),
                      backgroundColor: AppColors.white,
                      showShadow: false,
                      fontSize: 14,
                      isBorder: true,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: "Call",
                      fontSize: 14,

                      onPressed: () {},
                      textColor: AppColors.grey,
                      borderColor: AppColors.grey.withValues(alpha: 0.2),
                      backgroundColor: AppColors.white,
                      showShadow: false,
                      isBorder: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
