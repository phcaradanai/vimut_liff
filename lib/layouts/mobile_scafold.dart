import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xengistic_app/app/services/app_service.dart';
import 'package:xengistic_app/app/services/profile_service.dart';

class MobileScaffold extends GetView {
  final Widget childOutlet;

  const MobileScaffold({
    super.key,
    required this.childOutlet,
  });

  @override
  Widget build(BuildContext context) {
    double navIconSize = 25;
    double fabSize = 60;
    double bnbSize = 60 * 1.2;

    isRouteRight(route) {
      return Get.currentRoute == route;
    }

    List statusCheckOut = ['พักเที่ยง', 'เลิกงาน', 'อื่นๆ'];
    Rx remark = 'พักเที่ยง'.obs;
    return Scaffold(
      body: Obx(
        () => Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0.4,
                1,
              ],
              colors: [
                AppService.to.primaryColor.value.withOpacity(0.4),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, contraints) {
                  return childOutlet;
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: fabSize,
        height: fabSize,
        child: Obx(
          () => RawMaterialButton(
            fillColor: ProfileService.to.statusCheckIn
                ? const Color.fromARGB(255, 56, 225, 62)
                : const Color.fromARGB(255, 225, 56, 56),
            shape: const CircleBorder(
                side: BorderSide(
                    strokeAlign: -2,
                    width: 5,
                    color: Color.fromARGB(255, 255, 255, 255))),
            elevation: 0.0,
            onLongPress: () async {
              await Get.defaultDialog(
                title: 'Check-in Alert',
                middleText: ProfileService.to.statusCheckIn
                    ? 'Do you want to check-out?'
                    : 'Do you want to check-in?',
                textConfirm: 'OK',
                confirmTextColor: Colors.amberAccent,
                barrierDismissible: false,
                content: ProfileService.to.statusCheckIn
                    ? Card(
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.width * 0.8,
                          height: Get.height * 0.5,
                          padding: const EdgeInsets.all(8),
                          child: ListView(
                            children: [
                              const Center(
                                child: Text('Do you want to check-out?'),
                              ),
                              for (String status in statusCheckOut)
                                ObxValue(
                                  (p0) => ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: remark.value == status
                                          ? WidgetStatePropertyAll<Color>(
                                              Get.theme.primaryColor)
                                          : null,
                                    ),
                                    onPressed: () {
                                      remark.value = status;
                                      if (kDebugMode) {
                                        print("remark.value ${remark.value}");
                                      }
                                    },
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: remark.value == status
                                            ? Colors.white
                                            : null,
                                      ),
                                    ),
                                  ),
                                  false.obs,
                                ),
                              Obx(
                                () {
                                  return remark.value == statusCheckOut[2]
                                      ? TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: "...สาเหตุ...",
                                            border: OutlineInputBorder(),
                                          ),
                                          autofocus: true,
                                          controller: TextEditingController(
                                            text: remark.value,
                                          ),
                                        )
                                      : Container();
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
                onConfirm: () async {
                  try {
                    await HapticFeedback.vibrate();
                    if (ProfileService.to.statusCheckIn) {
                      await ProfileService.to.checkOut(remark.value);
                    } else {
                      await ProfileService.to.checkIn();
                    }
                    Get.back();
                  } catch (e) {
                    Get.snackbar(
                      "Process failed",
                      "failed: $e",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                textCancel: 'Cancel',
              );
            },
            onPressed: () {
              Get.toNamed('/jobs');
            },
            enableFeedback: true,
            child: Icon(
              ProfileService.to.statusCheckIn
                  ? Icons.directions_run_outlined
                  : Icons.pause_circle_outline_outlined,
              size: navIconSize,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: bnbSize,
        notchMargin: 3,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                iconSize: navIconSize,
                isSelected: isRouteRight('/'),
                onPressed: () {
                  Get.toNamed('/');
                },
                icon: const Icon(
                  Icons.home_outlined,
                  applyTextScaling: true,
                  semanticLabel: 'Home',
                ),
                style: const ButtonStyle(
                  enableFeedback: true,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                iconSize: navIconSize,
                isSelected: isRouteRight('/history'),
                onPressed: () {
                  Get.toNamed('/history');
                },
                icon: const Icon(
                  Icons.history_outlined,
                  applyTextScaling: true,
                  semanticLabel: 'History',
                ),
                style: const ButtonStyle(
                  enableFeedback: true,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                iconSize: navIconSize,
                isSelected: isRouteRight('/settings'),
                onPressed: () {
                  Get.toNamed('/settings');
                },
                icon: const Icon(
                  Icons.settings_outlined,
                  applyTextScaling: true,
                  semanticLabel: 'Settings',
                ),
                style: const ButtonStyle(
                  enableFeedback: true,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                iconSize: navIconSize,
                isSelected: isRouteRight('/profile'),
                onPressed: () {
                  Get.toNamed('/profile');
                },
                icon: const Icon(
                  Icons.person_outlined,
                  applyTextScaling: true,
                  semanticLabel: 'Profile',
                ),
                style: const ButtonStyle(
                  enableFeedback: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
