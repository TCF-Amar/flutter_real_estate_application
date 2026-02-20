import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

/// Header row with back button and centered "Verify Code" title.
class VerifyCodeHeader extends StatelessWidget {
  const VerifyCodeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppColors.background,
              ),
            ),
          ),
          const Spacer(),
          AppText(
            "Verify Code",
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: AppColors.white,
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// A single OTP digit input field.
class VerifyCodeInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const VerifyCodeInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

/// Row of 6 OTP input fields.
class VerifyCodeOtpRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onChanged;

  const VerifyCodeOtpRow({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (index) => VerifyCodeInputField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          onChanged: (value) => onChanged(index, value),
        ),
      ),
    );
  }
}

/// Paste button that triggers clipboard paste action.
class VerifyCodePasteButton extends StatelessWidget {
  final VoidCallback onTap;

  const VerifyCodePasteButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.content_paste, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              AppText(
                "Paste Code",
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Resend code row showing countdown or a tappable "Resend" link.
class VerifyCodeResendRow extends StatelessWidget {
  final bool canResend;
  final int countdown;
  final VoidCallback onResend;

  const VerifyCodeResendRow({
    super.key,
    required this.canResend,
    required this.countdown,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          "Didn't receive the code? ",
          color: AppColors.white.withValues(alpha: 0.7),
          fontSize: 14,
        ),
        if (canResend)
          InkWell(
            onTap: onResend,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: AppText(
                "Resend",
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          AppText(
            "Resend in ${countdown}s",
            color: AppColors.white.withValues(alpha: 0.5),
            fontSize: 14,
          ),
      ],
    );
  }
}
