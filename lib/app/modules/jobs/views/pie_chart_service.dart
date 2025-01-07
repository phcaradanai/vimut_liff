part of 'jobs_view.dart';

class PieChartService extends GetView<JobsController> {
  const PieChartService({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Obx(
        () => AspectRatio(
          aspectRatio: 10,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    controller.touchedIndex.value = -1;
                    return;
                  }
                  controller.touchedIndex.value =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: showingSections(),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    var jobLengthByService = controller.jobLengthByService;

    return List.generate(jobLengthByService.entries.length, (i) {
      final isTouched = i == controller.touchedIndex.value;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [
        Shadow(
          color: Colors.black,
          blurRadius: 2,
        )
      ];
      return PieChartSectionData(
        color: controller.colors[i],
        value: 100.0 * (jobLengthByService.entries.elementAt(i).value / 100),
        title: jobLengthByService.entries.elementAt(i).value?.toString() ??
            "Something wrong",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: _Badge(
          jobLengthByService.entries.elementAt(i).key,
          size: widgetSize,
          borderColor: Colors.black,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends GetView<JobsController> {
  const _Badge(
    this.serviceId, {
    required this.size,
    required this.borderColor,
  });
  final int serviceId;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: controller.findImageServiceType(serviceId),
      ),
    );
  }
}
