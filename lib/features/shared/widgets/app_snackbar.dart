import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void success(String message, {String? title}) => _show(
    message,
    title: title ?? 'Success',
    color: Colors.green,
    icon: Icons.check_circle,
  );

  static void error(String message, {String? title}) => _show(
    message,
    title: title ?? 'Error',
    color: Colors.red,
    icon: Icons.error,
  );

  static void info(String message, {String? title}) => _show(
    message,
    title: title ?? 'Info',
    color: Colors.blue,
    icon: Icons.info,
  );

  static void _show(
    String message, {
    required String title,
    required Color color,
    required IconData icon,
  }) {
    final context = Get.context;
    if (context == null) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color.withValues(alpha: 0.92),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
