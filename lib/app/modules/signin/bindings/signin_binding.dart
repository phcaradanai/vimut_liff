import 'package:get/get.dart';
import 'package:xengistic_app/app/modules/signin/controllers/signin_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(
      () => SignInController(),
    );
  }
}
