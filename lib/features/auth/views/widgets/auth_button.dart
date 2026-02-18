import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/app_button.dart';

/// AuthButton is now a simple wrapper around AppButton for backward compatibility
/// You can use AppButton directly in new code
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(text: text, onPressed: onPressed, isLoading: isLoading);
  }
}
