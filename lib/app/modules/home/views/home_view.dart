import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xengistic_app/app/modules/home/controllers/home_controller.dart';
import 'package:xengistic_app/app/routers/app_pages.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';
import 'package:xengistic_app/config.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Active Jobs',
                  style: TextStyle(
                    fontSize: Get.textTheme.titleMedium?.fontSize,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Get.toNamed('/jobs');
                  },
                  style: const ButtonStyle(enableFeedback: true),
                  child: Text(
                    'view all >',
                    style: TextStyle(
                      fontSize: Get.textTheme.bodySmall?.fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const ActiveJobCarousel(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Completed Jobs',
                  style: TextStyle(
                    fontSize: Get.textTheme.titleMedium?.fontSize,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/history');
                  },
                  style: const ButtonStyle(enableFeedback: true),
                  child: Text(
                    'view all >',
                    style: TextStyle(
                      fontSize: Get.textTheme.bodySmall?.fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DoneJobCarousel()
        ],
      ),
    );
  }
}

class ActiveJobCarousel extends GetView {
  const ActiveJobCarousel({super.key});
  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    HomeController controller = Get.put(HomeController());

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(
          () => CarouselSlider(
            items: controller.to.activeJobs
                .skip(0)
                .take(5 - 0)
                .map(
                  (item) => Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(48),
                                  child: controller.to.findImageServiceType(
                                      item['config']['form']['serviceTypeId']),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.to.findServiceType(item['config']
                                              ['form']
                                          ['serviceTypeId'])['displayName'] ??
                                      '',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  controller.to
                                              .findMarker(item['markerIdFrom'])[
                                          'displayName'] ??
                                      '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  controller.to.findMarker(
                                          item['markerIdTo'])['displayName'] ??
                                      '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'by',
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 30.0,
                                        width: 30.0,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: controller.to.findUserPic(
                                          controller.to
                                              .findUser(item['staffId']),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        controller.to.findUser(item['staffId'])[
                                                'displayName'] ??
                                            '',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        DateFormat('MM-dd hh:mm').format(
                                          DateTime.parse(item['ts'] ?? ''),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await JobsService.to
                                              .setSelectedJob(item);
                                          Get.toNamed(
                                              Routes.jobDetails(item['id']));
                                        },
                                        style: const ButtonStyle(
                                            enableFeedback: true),
                                        child: Text(
                                          'Go',
                                          style: TextStyle(
                                            fontSize: Get
                                                .textTheme.bodySmall?.fontSize,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              scrollDirection: Axis.horizontal,
              enableInfiniteScroll: false,
              autoPlayAnimationDuration: const Duration(milliseconds: 900),
              autoPlayInterval: const Duration(seconds: 4),
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              aspectRatio: 2.0,
              height: 170,
            ),
          ),
        )
        // ElevatedButton(
        //   onPressed: () => buttonCarouselController.nextPage(
        //       duration: Duration(milliseconds: 300), curve: Curves.linear),
        //   child: Text('→'),
        // ),
      ],
    );
  }
}

class DoneJobCarousel extends GetView {
  const DoneJobCarousel({super.key});
  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    HomeController controller = Get.put(HomeController());
    return Column(
      children: [
        Obx(
          () => CarouselSlider(
            items: controller.to.doneJobs
                .skip(0)
                .take(5 - 0)
                .map(
                  (item) => Card(
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
                                              BorderRadius.circular(12)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(48),
                                          child: controller.to
                                              .findImageServiceType(
                                                  item['config']['form']
                                                      ['serviceTypeId']),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        controller.to.findMarker(item != null
                                                    ? item['markerIdFrom']
                                                    : -1) !=
                                                null
                                            ? controller.to.findMarker(
                                                    item['markerIdFrom'])[
                                                'displayName']
                                            : '',
                                        style: TextStyle(
                                          fontSize:
                                              Get.textTheme.bodySmall?.fontSize,
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
                                                    item['markerIdTo'])?[
                                                'displayName'] ??
                                            '',
                                        style: TextStyle(
                                          fontSize:
                                              Get.textTheme.bodySmall?.fontSize,
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
                                        DateFormat('yyyy-MM-dd hh:mm').format(
                                          DateTime.parse(item['ts'] ?? ''),
                                        ),
                                        style: TextStyle(
                                          fontSize:
                                              Get.textTheme.bodySmall?.fontSize,
                                          overflow: TextOverflow.ellipsis,
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
                              await JobsService.to.setSelectedJob(item);
                              Get.toNamed(Routes.jobDetails(item['id']));
                            },
                            style: const ButtonStyle(enableFeedback: true),
                            child: Text(
                              'Detail',
                              style: TextStyle(
                                fontSize: Get.textTheme.bodySmall?.fontSize,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              height: 80,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              enableInfiniteScroll: false,
              enlargeFactor: 0,
            ),
          ),
        )
      ],
    );
  }
}

class HeadBanner extends GetView {
  const HeadBanner({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => SizedBox(
              height: 30,
              width: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: controller.to.photoProfile != null
                    ? Image.network(
                        appConfig['API_URL'] + controller.to.photoProfile,
                        fit: BoxFit.contain)
                    : Image.asset(
                        'assets/company/logo.png',
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Hello ,'),
                Text(
                  controller.to.profile['displayName'] ?? '',
                  style: TextStyle(
                    fontSize: Get.textTheme.titleMedium?.fontSize,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
