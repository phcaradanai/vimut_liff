import 'package:get/get.dart';
import 'package:xengistic_app/app/modules/jobs/controllers/jobs_controller.dart';

class JobsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(JobsController());
  }
}
