import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_button.dart';
import 'package:real_estate_app/features/auth/views/widgets/verify_code_widgets.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendCountdown = 60;
  Timer? _timer;
  bool _canResend = false;
  String? _source; // 'signup' or 'forgot-password'

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    _source = args?['source'] as String?;
    _startCountdown();
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _canResend = false;
    _resendCountdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _handleVerify();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _getVerificationCode() {
    return _codeControllers.map((c) => c.text).join();
  }

  void _handleVerify() {
    final code = _getVerificationCode();
    if (code.length == 6) {
      Get.snackbar(
        'Success',
        'Code verified successfully',
        backgroundColor: AppColors.success.withValues(alpha: 0.8),
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      if (_source == 'signup') {
        Get.toNamed(AppRoutes.selectCountry);
      } else {
        Get.toNamed(AppRoutes.resetPassword);
      }
    } else {
      Get.snackbar(
        'Error',
        'Please enter the complete 6-digit code',
        backgroundColor: AppColors.error.withValues(alpha: 0.8),
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void _handleResendCode() {
    if (!_canResend) return;
    Get.snackbar(
      'Code Sent',
      'A new verification code has been sent',
      backgroundColor: AppColors.primary.withValues(alpha: 0.8),
      colorText: AppColors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
    for (var controller in _codeControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    _startCountdown();
  }

  Future<void> _handlePaste() async {
    final clipboardData = await Clipboard.getData('text/plain');
    final pastedText = clipboardData?.text ?? '';
    if (pastedText.length == 6 && RegExp(r'^\d+$').hasMatch(pastedText)) {
      for (int i = 0; i < 6; i++) {
        _codeControllers[i].text = pastedText[i];
      }
      _focusNodes[5].unfocus();
      _handleVerify();
    } else {
      Get.snackbar(
        'Invalid Code',
        'Please paste a valid 6-digit code',
        backgroundColor: AppColors.error.withValues(alpha: 0.8),
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.images.getStart2),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.9),
                  AppColors.background.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),

          // Content
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                SizedBox(height: Get.height * 0.05),

                // Header with Back Button
                const VerifyCodeHeader(),

                SizedBox(height: Get.height * 0.08),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AppText(
                    "We've sent a 6-digit code to your email — enter it below to verify your account.",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white?.withValues(alpha: 0.9),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: Get.height * 0.05),

                // OTP Input Fields
                VerifyCodeOtpRow(
                  controllers: _codeControllers,
                  focusNodes: _focusNodes,
                  onChanged: _onCodeChanged,
                ),

                SizedBox(height: Get.height * 0.03),

                // Paste Button
                VerifyCodePasteButton(onTap: _handlePaste),

                SizedBox(height: Get.height * 0.04),

                // Resend Code with Countdown
                VerifyCodeResendRow(
                  canResend: _canResend,
                  countdown: _resendCountdown,
                  onResend: _handleResendCode,
                ),

                SizedBox(height: Get.height * 0.05),

                // Verify Button
                AuthButton(
                  text: "Verify",
                  onPressed: _handleVerify,
                  isLoading: controller.isLoading,
                ),

                SizedBox(height: Get.height * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
