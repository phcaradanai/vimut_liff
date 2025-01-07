part of 'profile_view.dart';

class ScoreCards extends GetView<ProfileController> {
  const ScoreCards({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          controller.toDayJobs.length.toString(),
                          style: TextStyle(
                            fontSize: Get.textTheme.titleLarge?.fontSize,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'TODAY \n JOBS',
                        style: TextStyle(
                          fontSize: Get.textTheme.labelSmall?.fontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          controller.failJobs.length.toString(),
                          style: TextStyle(
                            fontSize: Get.textTheme.titleLarge?.fontSize,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'FAILED \n JOBS',
                        style: TextStyle(
                          fontSize: Get.textTheme.labelSmall?.fontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          controller.doneJobs.length.toString(),
                          style: TextStyle(
                            fontSize: Get.textTheme.titleLarge?.fontSize,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'COMPETED \n JOBS',
                        style: TextStyle(
                          fontSize: Get.textTheme.labelSmall?.fontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
