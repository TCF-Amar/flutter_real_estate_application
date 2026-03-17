import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class CancelVisitDialog extends StatelessWidget {
  final TextEditingController reasonController;
  final VoidCallback onCancel;
  final bool isCancelling;

  const CancelVisitDialog({
    super.key,
    required this.reasonController,
    required this.onCancel,
    required this.isCancelling,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Cancel ",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    TextSpan(text: "Visit?"),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const AppText(
                "Are you sure you want to cancel your scheduled site visit?",
                color: AppColors.textSecondary,
                fontSize: 10,
                overflow: TextOverflow.visible,
              ),

              const SizedBox(height: 10),

              /// REASON LABEL
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(text: "Reason "),
                    TextSpan(
                      text: "(optional)",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// TEXTFIELD
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Write something",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: "No",
                      isBorder: true,
                      borderColor: AppColors.grey,
                      backgroundColor: Colors.transparent,
                      showShadow: false,
                      textColor: AppColors.textSecondary,
                      borderRadius: 12,
                      fontSize: 12,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: isCancelling ? "Cancelling..." : "Yes, Cancel",
                      isBorder: false,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      borderRadius: 12,
                      fontSize: 12,
                      onPressed: isCancelling ? null : onCancel,
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
