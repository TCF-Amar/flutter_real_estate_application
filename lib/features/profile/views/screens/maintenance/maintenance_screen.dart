import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/features/profile/views/screens/maintenance/maintenance_request_screen.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _MaintenanceEmptyBody());
  }
}

class _MaintenanceEmptyBody extends StatelessWidget {
  const _MaintenanceEmptyBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Image.asset(Assets.images.maintenance),
            const SizedBox(height: 20),
            AppText.large("No Maintenance Request Yet"),
            const SizedBox(height: 10),
            AppText(
              "Everything looks great! You haven’t raised any maintenance requests yet. If you face an issue, you can submit a request here.",
              textAlign: .center,
            ),
            const SizedBox(height: 20),
            AppButton(
              text: "New Request",
              onPressed: () {
                Get.to(() => MaintenanceRequestScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
