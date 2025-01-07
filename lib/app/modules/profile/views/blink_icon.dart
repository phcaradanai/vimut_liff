// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimationControllerX extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  AnimationController get controller => _controller;
  Animation<double> get animation => _animation;

  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void onClose() {
    _controller.dispose();
    super.onClose();
  }
}

class BlinkIcon extends GetView {
  final AnimationControllerX animationControllerX =
      Get.put(AnimationControllerX());
  BlinkIcon({
    super.key,
    required this.color,
  });
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnimationControllerX>(
      builder: (controller) {
        return AnimatedBuilder(
          animation: controller.animation,
          builder: (context, child) {
            return Icon(
              Icons.circle,
              color: color.withOpacity(controller.animation.value),
              size: 15.0,
              shadows: [
                Shadow(
                  blurRadius: 30.0 * controller.animation.value,
                  color: color,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
