import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/utils/colors.dart';

enum SnackbarType {
  success,
  danger,
  warning,
  info,
}

class CustomSnackBar {
  static showCustomSnackBar({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition? snackPosition,
    SnackbarType? snackbarType,
    Color? color,
    IconData? icon,
    Color? iconColor,
  }) {
    Get.snackbar(
      title,
      message,
      duration: duration ?? const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      colorText: Colors.white,
      backgroundColor: color ??
          (snackbarType == SnackbarType.success
              ? AppColors.success
              : snackbarType == SnackbarType.danger
                  ? AppColors.dangerDark
                  : snackbarType == SnackbarType.warning
                      ? AppColors.warning
                      : snackbarType == SnackbarType.info
                          ? AppColors.primaryBlue
                          : Get.theme.primaryColor),
      snackPosition: snackPosition ?? SnackPosition.TOP,
      icon: Icon(
        icon ??
            (snackbarType == SnackbarType.success
                ? Icons.check_circle
                : snackbarType == SnackbarType.danger
                    ? Icons.error
                    : snackbarType == SnackbarType.warning
                        ? Icons.warning
                        : snackbarType == SnackbarType.info
                            ? Icons.info
                            : null),
        color: iconColor ?? Colors.white,
      ),
    );
  }

  static showCustomToast({
    String? title,
    required String message,
    Duration? duration,
    SnackPosition? snackPosition,
    SnackbarType? snackbarType,
    Color? color,
    IconData? icon,
    Color? iconColor,
  }) {
    Get.rawSnackbar(
      title: title,
      message: message,
      onTap: (snack) {
        Get.closeAllSnackbars();
      },
      duration: duration ?? const Duration(seconds: 3),
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: color ??
          (snackbarType == SnackbarType.success
              ? Colors.green
              : snackbarType == SnackbarType.danger
                  ? Colors.red
                  : snackbarType == SnackbarType.warning
                      ? Colors.orange
                      : Get.theme.primaryColor),
      snackPosition: snackPosition ?? SnackPosition.TOP,
      icon: Icon(
        icon ??
            (snackbarType == SnackbarType.success
                ? Icons.check_circle
                : snackbarType == SnackbarType.danger
                    ? Icons.error
                    : snackbarType == SnackbarType.warning
                        ? Icons.warning
                        : null),
        color: iconColor ?? Colors.white,
      ),
      //overlayBlur: 0.8,
    );
  }
}
