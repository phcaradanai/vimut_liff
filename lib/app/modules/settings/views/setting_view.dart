import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xengistic_app/app/modules/settings/controllers/setting_controller.dart';
import 'package:xengistic_app/app/services/app_service.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(
            8,
          ),
          child: Column(
            children: [
              SizedBox(
                width: Get.width,
                height: 60,
                child: Row(
                  children: [
                    const Text(
                      'THEME COLOR :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ButtonBar(
                      children: [
                        for (var color in controller.themeColor)
                          Container(
                            decoration: const ShapeDecoration(
                              shadows: [
                                BoxShadow(
                                  blurRadius: 1,
                                  blurStyle: BlurStyle.outer,
                                  spreadRadius: 1,
                                  offset: Offset.zero,
                                ),
                              ],
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.circle,
                                color: color,
                              ),
                              onPressed: () {
                                AppService.to.primaryColor.value = color;
                              },
                              style: const ButtonStyle(
                                enableFeedback: true,
                              ),
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Get.width,
                height: 60,
                child: Row(
                  children: [
                    const Text(
                      'DARK MODE :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(
                      () => Switch(
                        thumbIcon: WidgetStatePropertyAll<Icon>(
                            controller.isDarkMode
                                ? const Icon(Icons.brightness_2_outlined)
                                : const Icon(Icons.wb_sunny_outlined)),
                        value: controller.isDarkMode,
                        onChanged: (val) {
                          controller.setDarkMode(val);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
