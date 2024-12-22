import 'package:flutter/material.dart';

class CommonSnackBar {
  static void show({
    required BuildContext context,
    IconData? iconData,
    Color? iconColor,
    required String message,
    required Color backgroundColor,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (iconData != null)
            Icon(iconData, color: iconColor ?? Colors.white),
          if (iconData != null)
            const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
