import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xengistic_app/api/main_provider.dart';

import 'package:xengistic_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:xengistic_app/app/modules/profile/views/blink_icon.dart';

part 'image_label.dart';
part 'score_cards.dart';
part 'service_manage.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(14, 255, 255,
                              255), // Replace with your desired color
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Container(
                        height: 160,
                        width: 160,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(21, 255, 255,
                              255), // Replace with your desired color
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(42, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const ImageLabel(),
          ],
        ),
        const ScoreCards(),
        const ServiceManage()
      ],
    );
  }
}
