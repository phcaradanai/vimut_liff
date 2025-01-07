import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xengistic_app/app/services/app_service.dart';

ThemeData appTheme() {
  bool isDark = Get.isDarkMode;
  return ThemeData(
    primaryColor: AppService.to.primaryColor.value,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppService.to.primaryColor.value,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ),
    useMaterial3: true,
  );
}
