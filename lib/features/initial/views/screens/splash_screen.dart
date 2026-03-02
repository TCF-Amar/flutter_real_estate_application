import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/services/auth_services.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for the first frame so the navigator is ready before routing.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthServices>().checkAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText('Real Estate', fontSize: 24, fontWeight: FontWeight.bold),
            SizedBox(height: 16),
            AppText(
              'Find. Rent. Own. All in one place',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
