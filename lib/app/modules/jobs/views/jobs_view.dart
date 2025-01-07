import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:xengistic_app/app/modules/jobs/controllers/jobs_controller.dart';

import 'package:xengistic_app/app/routers/app_pages.dart';
import 'package:xengistic_app/app/services/app_service.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';

part 'pie_chart_service.dart';
part 'search_box.dart';

class JobsView extends GetView<JobsController> {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(() async {
        controller.filterAllData();
      }),
      builder: (context, snapshot) => Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'My Jobs',
                    style: TextStyle(
                      fontSize: Get.textTheme.titleMedium?.fontSize,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => controller.jobLengthByService.entries.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                'TODAY SERVICE JOB COUNT',
                                style: TextStyle(
                                  fontSize: Get.textTheme.labelMedium?.fontSize,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const PieChartService(),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: Get.width - 10,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 3,
                  ),
                  alignment: Alignment.center,
                  child: const SearchBox(),
                ),
              ],
            ),
            Card(
              child: Column(
                children: [
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.category.length,
                      (index) => FutureBuilder(
                        future: Future(
                          () async {
                            await controller.filterAllData();
                          },
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Obx(
                              () => ElevatedButton(
                                style: ButtonStyle(
                                    padding: const WidgetStatePropertyAll<
                                        EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                    ),
                                    backgroundColor: controller
                                                .selectedCategory.value ==
                                            controller.category[index]['code']
                                        ? WidgetStatePropertyAll<Color>(
                                            AppService.to.primaryColor.value
                                                .withOpacity(0.3),
                                          )
                                        : null,
                                    enableFeedback: true),
                                onPressed: () async {
                                  if (controller.selectedCategory.value ==
                                      controller.category[index]['code']) {
                                    return;
                                  }
                                  controller.selectedCategory.value =
                                      controller.category[index]['code'];
                                  await controller.filterAllData();
                                },
                                child: Text(
                                  controller.category[index]['text'],
                                  style: TextStyle(
                                      color: controller
                                                  .selectedCategory.value ==
                                              controller.category[index]['code']
                                          ? Get.theme.colorScheme.surface
                                          : null),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ).toList(),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => Column(
                        children: List.generate(
                          controller.filteredJobs.length,
                          (index) => Card(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 26,
                                              width: 26,
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: SizedBox.fromSize(
                                                  size:
                                                      const Size.fromRadius(48),
                                                  child: controller.to
                                                      .findImageServiceType(
                                                          controller.filteredJobs[
                                                                          index][
                                                                      'config']
                                                                  ['form'][
                                                              'serviceTypeId']),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                controller.to.findMarker(controller
                                                                        .filteredJobs[
                                                                    index] !=
                                                                null
                                                            ? controller.filteredJobs[
                                                                    index]
                                                                ['markerIdFrom']
                                                            : -1) !=
                                                        null
                                                    ? controller.to.findMarker(
                                                            controller.filteredJobs[
                                                                    index]
                                                                ['markerIdFrom'])[
                                                        'displayName']
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: Get.textTheme
                                                      .bodySmall?.fontSize,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                controller.to.findMarker(
                                                            controller.filteredJobs[
                                                                    index][
                                                                'markerIdTo'])?[
                                                        'displayName'] ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: Get.textTheme
                                                      .bodySmall?.fontSize,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Center(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_month,
                                              ),
                                              Text(
                                                DateFormat('yyyy-MM-dd hh:mm')
                                                    .format(
                                                  DateTime.parse(
                                                      controller.filteredJobs[
                                                              index]['ts'] ??
                                                          ''),
                                                ),
                                                style: TextStyle(
                                                  fontSize: Get.textTheme
                                                      .bodySmall?.fontSize,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await JobsService.to.setSelectedJob(
                                          controller.filteredJobs[index]);
                                      Get.toNamed(Routes.jobDetails(controller
                                          .filteredJobs[index]['id']));
                                    },
                                    style: const ButtonStyle(
                                      enableFeedback: true,
                                    ),
                                    child: Text(
                                      'Detail',
                                      style: TextStyle(
                                        fontSize:
                                            Get.textTheme.bodySmall?.fontSize,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).toList(),
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
