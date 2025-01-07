import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xengistic_app/app/routers/app_pages.dart';
import 'package:xengistic_app/app/services/auth_service.dart';

class EnsureAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!AuthService.to.isLoggedInValue) {
      final newRoute = Routes.signInThen(route!);
      return RouteSettings(name: newRoute);
    }
    return null;
  }
}
