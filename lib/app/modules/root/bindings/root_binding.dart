import 'package:get/get.dart';
import 'package:xengistic_app/app/modules/root/controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
      () => RootController(),
    );
  }
}
