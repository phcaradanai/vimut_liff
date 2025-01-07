import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:xengistic_app/app/modules/job_details/controllers/job_detail_controller.dart';

import 'package:xengistic_app/app/services/app_service.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';

part 'take_picture.dart';

class JobDetailView extends GetView<JobDetailController> {
  const JobDetailView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> takePicture(firstCamera) async {
      Get.dialog(
        TakePictureScreen(
          camera: firstCamera,
        ),
        transitionCurve: Curves.linearToEaseOut,
        transitionDuration: const Duration(
          seconds: 1,
        ),
      );

      // await Future.delayed(
      //   Duration(seconds: 5),
      // );
      // Get.back();
    }

    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: const [0],
          colors: [
            Get.theme.colorScheme.surface,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Job task: ${controller.selectJob['id']}',
                        style: TextStyle(
                          fontSize: Get.textTheme.titleMedium?.fontSize,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        style: TextStyle(
                          fontSize: Get.textTheme.bodySmall?.fontSize,
                          overflow: TextOverflow.ellipsis,
                        ),
                        DateFormat('yyyy-MM-dd').format(
                          DateTime.parse(
                            controller.selectJob.containsKey('ts')
                                ? controller.selectJob['ts']
                                : DateTime.now().toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const CardDetail(),
                  Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Grab at',
                            style: TextStyle(
                              fontSize: Get.textTheme.bodyMedium?.fontSize,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${controller.jobCtrl.findMarker(controller.selectJob['markerIdFrom'])?['config']?['floor']} Fl.",
                            style: TextStyle(
                              fontSize: Get.textTheme.bodyMedium?.fontSize,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.forward,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Obx(
                            () => Text(
                              controller.jobCtrl.findMarker(
                                          controller.selectJob['markerIdFrom'])[
                                      'displayName'] ??
                                  '',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppService.to.primaryColor.value,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () {
                      return Column(
                        children: [
                          controller.srcEventImage('PICKUP') != null
                              ? SizedBox(
                                  height: 310,
                                  width: 310,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: controller.srcEventImage('PICKUP'),
                                  ),
                                )
                              : Container(),
                          controller.isPorterConfirm
                              ? Center(
                                  child: Column(
                                    children: [
                                      controller.isRightEvent('PICKUP')
                                          ? Column(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final cameras =
                                                        await availableCameras();
                                                    if (cameras.isEmpty) {
                                                      return;
                                                    }
                                                    final firstCamera =
                                                        cameras.first;
                                                    await takePicture(
                                                        firstCamera);
                                                  },
                                                  style: const ButtonStyle(
                                                    shape:
                                                        WidgetStatePropertyAll<
                                                            OutlinedBorder>(
                                                      ContinuousRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    enableFeedback: true,
                                                  ),
                                                  child: const Icon(
                                                    Icons.photo_camera,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      );
                    },
                  ),
                  Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Drop at',
                            style: TextStyle(
                              fontSize: Get.textTheme.bodyMedium?.fontSize,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${controller.jobCtrl.findMarker(controller.selectJob['markerIdTo'])?['config']?['floor']} Fl.",
                            style: TextStyle(
                              fontSize: Get.textTheme.bodyMedium?.fontSize,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.forward),
                          const SizedBox(
                            width: 10,
                          ),
                          controller.selectJob['markerIdTo'] != null
                              ? Obx(
                                  () {
                                    return Text(
                                      controller.jobCtrl.findMarker(controller
                                                  .selectJob['markerIdTo'])[
                                              'displayName'] ??
                                          '',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppService.to.primaryColor.value,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () {
                      return Column(
                        children: [
                          controller.srcEventImage('DROPOFF') != null
                              ? SizedBox(
                                  height: 310,
                                  width: 310,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: controller.srcEventImage('DROPOFF'),
                                  ),
                                )
                              : Container(),
                          controller.isPorterConfirm
                              ? Center(
                                  child: Column(
                                    children: [
                                      controller.isRightEvent('DROPOFF')
                                          ? Column(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final cameras =
                                                        await availableCameras();
                                                    if (cameras.isEmpty) {
                                                      return;
                                                    }
                                                    final firstCamera =
                                                        cameras.first;
                                                    await takePicture(
                                                        firstCamera);
                                                  },
                                                  style: const ButtonStyle(
                                                    shape:
                                                        WidgetStatePropertyAll<
                                                            OutlinedBorder>(
                                                      ContinuousRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    enableFeedback: true,
                                                  ),
                                                  child: const Icon(
                                                    Icons.photo_camera,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      );
                    },
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    height: 80,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Timeline(),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                          left: 8,
                          right: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 40.0,
                              width: 40.0,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: controller.jobCtrl.findUserPic(
                                controller.jobCtrl.findUser(
                                  controller.selectJob['staffId'],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Order by",
                              style: TextStyle(
                                fontSize: Get.textTheme.labelLarge?.fontSize,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              controller.jobCtrl.findUser(
                                controller.selectJob['staffId'],
                              )['displayName'],
                              style: TextStyle(
                                fontSize: Get.textTheme.labelLarge?.fontSize,
                                overflow: TextOverflow.ellipsis,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  controller.selectJob['config']['form']['note'] != ''
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Icon(
                                  Icons.comment,
                                  size: 40,
                                  color: AppService.to.primaryColor.value,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Obx(
                                () => Card(
                                  margin: const EdgeInsets.only(
                                    right: 10,
                                    bottom: 10,
                                  ),
                                  shape: ContinuousRectangleBorder(
                                    side: BorderSide(
                                      color: AppService.to.primaryColor.value,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.selectJob['config']['form']
                                              ['note'],
                                          style: TextStyle(
                                            fontSize: Get.textTheme.titleMedium
                                                ?.fontSize,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            controller.jobCtrl.findNextStatus(controller.selectJob) != ''
                ? const BottomButton()
                : Container(),
          ],
        ),
      ),
    );
  }
}

class Timeline extends GetView<JobDetailController> {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          for (Map<dynamic, dynamic> tl in controller.jobCtrl.findTimeLine(
            controller.selectJob,
          ))
            Expanded(
              flex: 1,
              child: TimelineTile(
                beforeLineStyle: LineStyle(
                  thickness: 6,
                  color: tl['color'],
                ),
                indicatorStyle: IndicatorStyle(
                  height: 30,
                  width: 30,
                  color: tl['color'],
                  iconStyle: IconStyle(
                    iconData: tl['icon'],
                    color: Colors.white,
                  ),
                ),
                startChild: Center(
                  child: Text(
                    tl['title'],
                    style: TextStyle(
                      fontSize: Get.textTheme.labelSmall?.fontSize,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                axis: TimelineAxis.horizontal,
                alignment: TimelineAlign.center,
                afterLineStyle: LineStyle(
                  thickness: 6,
                  color: tl['color'],
                ),
                endChild: Center(
                  child: Text(
                    tl.containsKey('ts') ? tl['ts'] : '',
                    style: TextStyle(
                      fontSize: Get.textTheme.bodySmall?.fontSize,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CardDetail extends GetView<JobDetailController> {
  const CardDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        alignment: Alignment.topLeft,
        height: 170,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48), // Image radius
                            child: controller.jobCtrl.findImageServiceType(
                                controller.selectJob.containsKey('config')
                                    ? controller.selectJob['config']['form']
                                        ['serviceTypeId']
                                    : null),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text(
                          controller.jobCtrl.findServiceType(
                                  controller.selectJob['config']['form']
                                      ['serviceTypeId'])['displayName'] ??
                              '',
                          style: TextStyle(
                            fontSize: Get.textTheme.bodyLarge?.fontSize,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            controller.selectJob['config']['checkList'].isNotEmpty
                ? Expanded(
                    flex: 1,
                    child: Wrap(
                      verticalDirection: VerticalDirection.down,
                      runAlignment: WrapAlignment.start,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      children: [
                        for (String clCode in controller.selectJob['config']
                            ['checkList'])
                          Card(
                            child: Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(8.0),
                              child: controller.jobCtrl.findImageCheckList(
                                clCode,
                                controller.selectJob,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : Container(),
            Expanded(
              flex: 1,
              child: Wrap(
                verticalDirection: VerticalDirection.down,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                children: [
                  Card(
                    child: Container(
                      height: 40,
                      width: 42,
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(8.0),
                      child: controller.jobCtrl.findImageByCode(
                        controller.selectJob['config']['caution'],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      height: 40,
                      width: 42,
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: controller.jobCtrl.findImageByCode(
                        controller.selectJob['config']['urgency'],
                      ),
                    ),
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

class BottomButton extends GetView<JobDetailController> {
  const BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Expanded(
              flex: 1,
              child: ['START'].contains(
                controller.jobCtrl.findNextStatus(controller.selectJob),
              )
                  ? ElevatedButton(
                      onPressed: controller.jobCtrl.busy.value
                          ? null
                          : () {
                              controller.jobCtrl.cancelJob(
                                controller.selectJob,
                              );
                            },
                      style: const ButtonStyle(
                        enableFeedback: true,
                      ),
                      child: Text(
                        'CANCEL',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Get.theme.colorScheme.error),
                      ),
                    )
                  : Container(),
            ),
          ),
          const SizedBox(
            width: 60,
          ),
          Obx(
            () => Expanded(
              flex: 1,
              child: !['DONE', 'CANCELLED', ''].contains(
                controller.jobCtrl.findNextStatus(controller.selectJob),
              )
                  ? ElevatedButton(
                      onPressed: controller.jobCtrl.busy.value
                          ? null
                          : () {
                              controller.jobCtrl
                                  .updateJob(controller.selectJob);
                            },
                      style: const ButtonStyle(
                        enableFeedback: true,
                      ),
                      child: Text(
                        controller.jobCtrl
                                .findNextStatus(controller.selectJob) ??
                            '',
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
