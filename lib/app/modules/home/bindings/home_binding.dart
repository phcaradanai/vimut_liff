import 'package:get/get.dart';
import 'package:xengistic_app/app/modules/home/controllers/home_controller.dart';
import 'package:xengistic_app/app/modules/jobs/controllers/jobs_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(JobsController());
    Get.put(HomeController());
  }
}
