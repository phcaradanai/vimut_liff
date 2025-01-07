import 'package:get/get.dart';
import 'package:xengistic_app/app/modules/history/controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HistoryController());
  }
}
