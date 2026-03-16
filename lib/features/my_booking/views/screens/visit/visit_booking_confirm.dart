import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/my_booking/models/visit_confirmation_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VisitBookingConfirm extends StatelessWidget {
  final VisitConfirmationModel model;
  const VisitBookingConfirm({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Simulated background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemBuilder: (context, index) => const Center(
                  child: Icon(Icons.close, size: 20, color: AppColors.primary),
                ),
                itemCount: 100,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Success Icon with Glow
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Heading
                const AppText(
                  "Booking Confirmed!",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                // Subtext
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textTertiary,
                    ),
                    children: [
                      const TextSpan(text: "Your site visit for "),
                      TextSpan(
                        text: "** ${model.property.title ?? ""} **",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const TextSpan(text: " has been successfully scheduled."),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Info Card
                AppContainer(
                  padding: const EdgeInsets.all(20),
                  color: AppColors.grey.withValues(alpha: 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: AppColors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            AppText(
                              model.date,
                              fontSize: 12,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: AppColors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            AppText(
                              "${model.startTime} -to- ${model.endTime}",
                              fontSize: 12,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // const Spacer(),
                const SizedBox(height: 50),
                // Buttons
                AppButton(
                  text: "View My Bookings",
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.main, arguments: 3);
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: "Back to Home",

                  backgroundColor: Colors.white,
                  textColor: AppColors.grey,
                  isBorder: true,
                  borderColor: AppColors.grey.withValues(alpha: 0.3),
                  showShadow: false,
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.main, arguments: 0);
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
