import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static showSnakBar({required String title, required String content}) {
    Get.snackbar(
      title,
      content,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
