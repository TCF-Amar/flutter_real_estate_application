import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/views/widgets/support_widgets/req_suc_dialog.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ContactSupportSection extends StatelessWidget {
  const ContactSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dropItem = ["Property", "Payment", "Booking", "Document"];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              "Contact Support?",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              // color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const AppText(
              "Subject/issue",
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 10),
            DropdownFlutter(
              items: [...dropItem],
              hintText: "Select",
              onChanged: (value) {},
              decoration: CustomDropdownDecoration(
                closedBorder: Border.all(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
                closedBorderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 15),
            const AppText(
              "Message",
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 10),
            AppTextFormField(
              maxLines: 5,
              showContainerBorder: false,
              fillColor: const Color(0xFFF7F7F9),
              containerBorderRadius: BorderRadius.circular(16),
              hintText: "Please describe your Issue in detail",
            ),
            const SizedBox(height: 24),
            AppButton(
              text: "Send request",
              onPressed: () => showRequestSuccess(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
