import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppService extends GetxService {
  final _box = GetStorage();
  final _imgUplK = 'image.upload';

  static AppService get to => Get.put(AppService());

  get imageUpload => _box.read(_imgUplK);

  var colors = [];

  Rx<MaterialColor> primaryColor = Colors.pink.obs;
  RxBool isDarkMode = false.obs;
  Future<void> setImageUpload(List<dynamic>? imgUpl) async {
    await _box.write(_imgUplK, imgUpl);
  }

  cancelTimer(Timer? timer) {
    timer?.cancel();
  }

  Future<void> showLoading(fn, {fnProps}) async {
    try {
      Get.dialog(
        Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 100,
          ),
        ),
        barrierDismissible: false,
      );
      await Future.delayed(const Duration(seconds: 1));

      if (fnProps != null) {
        await fn(fnProps);
      } else {
        await fn();
      }
    } catch (e) {
      Get.snackbar(
        "Process failed",
        "failed: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      Get.back();
    }
  }
}
