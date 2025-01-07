import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xengistic_app/app/modules/history/controllers/history_controller.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';
import 'package:xengistic_app/app/services/utils.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Get.textTheme.bodyLarge?.fontSize,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            width: Get.width,
            child: Row(
              children: [
                SizedBox(
                  height: 120,
                  width: Get.width,
                  child: SizedBox(
                    height: 120,
                    width: Get.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: controller.scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: controller.getAgo7Days.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => MaterialButton(
                            autofocus: containsMap(controller.myDate,
                                controller.getAgo7Days[index]),
                            shape: const CircleBorder(),
                            focusNode: controller.focusNodes[index],
                            enableFeedback: true,
                            onPressed: () {
                              controller.myDate
                                  .addAll(controller.getAgo7Days[index]);
                            },
                            child: Column(
                              children: [
                                Text(
                                  controller.getAgo7Days[index]['month'],
                                  style: TextStyle(
                                    color: containsMap(controller.myDate,
                                            controller.getAgo7Days[index])
                                        ? null
                                        : Get.theme.colorScheme.secondary
                                            .withOpacity(0.4),
                                  ),
                                ),
                                Center(
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Center(
                                      child: Card(
                                        color: containsMap(controller.myDate,
                                                controller.getAgo7Days[index])
                                            ? Colors.black
                                            : Get.theme.cardColor
                                                .withOpacity(0.1),
                                        margin: const EdgeInsets.all(8),
                                        shape: const CircleBorder(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              controller.getAgo7Days[index]
                                                  ['date'],
                                              style: TextStyle(
                                                color: containsMap(
                                                        controller.myDate,
                                                        controller
                                                            .getAgo7Days[index])
                                                    ? Colors.white
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  controller.getAgo7Days[index]['day'],
                                  style: TextStyle(
                                    color: containsMap(controller.myDate,
                                            controller.getAgo7Days[index])
                                        ? null
                                        : Get.theme.colorScheme.secondary
                                            .withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 130,
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.jobAllInMyDate.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: Future(
                        () async {
                          List jobEvents = [];
                          try {
                            jobEvents = await JobsService.to.fetchGetJobEvents(
                                controller.jobAllInMyDate[index]['id']);
                          } catch (e) {
                            Get.snackbar(
                              "Process failed",
                              "failed: $e",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                          controller.jobAllInMyDate[index]['jobEvents'] =
                              jobEvents;
                        },
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Row(
                            children: [
                              Center(
                                child: SizedBox(
                                  height: 130,
                                  width: Get.width * 0.3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('............'),
                                      Text(
                                        DateFormat('hh:mm').format(
                                          DateTime.parse(
                                            controller.jobAllInMyDate[index]
                                                ['ts'],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  child: Container(
                                    height: 130,
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.findServiceType(controller
                                                      .jobAllInMyDate[index]
                                                  ['config']['form']
                                              ['serviceTypeId'])['displayName'],
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: Get.width,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.timelapse,
                                                color: Get.theme.hintColor,
                                              ),
                                              Text(
                                                DateFormat('hh:mm').format(
                                                  DateTime.parse(
                                                    controller.jobAllInMyDate[
                                                        index]['ts'],
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  color: Get.theme.hintColor,
                                                ),
                                              ),
                                              Icon(
                                                Icons.linear_scale,
                                                color: Get.theme.hintColor,
                                              ),
                                              Text(
                                                DateFormat('hh:mm').format(
                                                  DateTime.parse(
                                                    controller.jobAllInMyDate[
                                                            index]['info']
                                                        ['lastEvent']['ts'],
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  color: Get.theme.hintColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Obx(
                                          () {
                                            return SizedBox(
                                              height: 40,
                                              width: Get.width,
                                              child: Row(
                                                children: [
                                                  for (Map<dynamic, dynamic> tl
                                                      in controller.findTimeLine(
                                                          controller
                                                                  .jobAllInMyDate[
                                                              index]))
                                                    Stack(
                                                      children: [
                                                        Icon(
                                                          Icons.label,
                                                          size: 40,
                                                          color: tl['color'],
                                                        ),
                                                        Positioned(
                                                          left: 9,
                                                          top: 10,
                                                          child: Icon(
                                                            tl['icon'],
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
