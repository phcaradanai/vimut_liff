import 'package:get/get.dart';
import 'package:xengistic_app/app/modules/job_details/controllers/job_detail_controller.dart';

class JobDetailViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobDetailController>(
      () => JobDetailController(
        Get.parameters['jobId'] ?? '',
      ),
    );
  }
}
