import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xengistic_app/app/services/app_service.dart';

class SettingController extends GetxController {
  var themeColor = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];

  get isDarkMode => AppService.to.isDarkMode.value;

  setDarkMode(darkMode) {
    AppService.to.isDarkMode.value = darkMode;
  }
}
