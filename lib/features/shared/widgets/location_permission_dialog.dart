import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/utils/location_permission_util.dart';

Future<void> showLocationDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enable Location Access",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              const Text(
                "Allow location access to find properties near you and personalize your experience.",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Maybe later"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await LocationPermissionUtil.requestPermission();
                        Get.back();
                      },
                      child: const Text("Allow"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
