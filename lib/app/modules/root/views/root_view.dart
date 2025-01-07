import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xengistic_app/app/modules/root/controllers/root_controller.dart';
import 'package:xengistic_app/app/routers/app_pages.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet(
      initialRoute: Routes.home,
      anchorRoute: '/',
    );
  }
}
