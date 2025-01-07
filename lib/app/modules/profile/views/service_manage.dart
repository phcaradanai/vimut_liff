part of 'profile_view.dart';

class ServiceManage extends GetView<ProfileController> {
  const ServiceManage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Service Manage',
                ),
                const SizedBox(
                  width: 2,
                ),
                BlinkIcon(
                  color:
                      controller.canModiService ? Colors.green : Colors.amber,
                ),
                // Icon(
                //   Icons.circle,
                //   color: controller.canModiService
                //       ? Colors.green
                //       : Colors.amber,
                // ),
              ],
            ),
            Obx(
              () => Wrap(
                direction: axisDirectionToAxis(AxisDirection.right),
                children: [
                  for (var service in controller.serviceTypes)
                    IconButton(
                      onPressed: () async {
                        List? exist = controller.serviceUse
                            .where((element) => element == service['id'])
                            .toList();
                        if (exist.isNotEmpty) {
                          controller.serviceUse.removeWhere(
                              (element) => element == service['id']);
                        } else {
                          controller.serviceUse.add(service['id']);
                        }
                        try {
                          var api = await mainProvider();

                          await api.post(
                            '/api/porter/service-change',
                            data: {
                              'serviceTypeIds': controller.serviceUse,
                            },
                          );
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
                      icon: Column(
                        children: [
                          Tooltip(
                            message: service['displayName'],
                            preferBelow: false,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(24),
                                child: controller.serviceUse
                                        .contains(service['id'])
                                    ? controller.findImageServiceType(
                                        service['id'],
                                      )
                                    : ColorFiltered(
                                        colorFilter: const ColorFilter.mode(
                                          Colors.grey,
                                          BlendMode.saturation,
                                        ),
                                        child: controller.findImageServiceType(
                                          service['id'],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      style: const ButtonStyle(
                          shape: WidgetStatePropertyAll<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                          ),
                          enableFeedback: true),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
