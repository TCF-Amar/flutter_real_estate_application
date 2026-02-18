import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void success(String message, {String title = "Success"}) {
    _show(
      title,
      message,
      backgroundColor: Colors.green.withValues(alpha: 0.8),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void error(String message, {String title = "Error"}) {
    _show(
      title,
      message,
      backgroundColor: Colors.red.withValues(alpha: 0.8),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void info(String message, {String title = "Info"}) {
    _show(
      title,
      message,
      backgroundColor: Colors.blue.withValues(alpha: 0.8),
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  static void _show(
    String title,
    String message, {
    required Color backgroundColor,
    required Widget icon,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      icon: icon,
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      snackStyle: SnackStyle.FLOATING,
    );
  }
}
