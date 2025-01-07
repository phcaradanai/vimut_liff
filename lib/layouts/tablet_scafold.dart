// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabletScaffold extends StatelessWidget {
  final Widget childOutlet;

  TabletScaffold({
    super.key,
    required this.childOutlet,
  });
  double navIconSize = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: LayoutBuilder(builder: (context, contraints) {
              return childOutlet;
            }),
          ),
        ),
      ),
      // bottomNavigationBar: const NsBottomNav(),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: RawMaterialButton(
          fillColor: Colors.green.shade200,
          shape: const CircleBorder(),
          elevation: 0.0,
          onPressed: () {},
          enableFeedback: true,
          child: Icon(
            Icons.directions_run_rounded,
            size: navIconSize,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              onPressed: () {
                Get.toNamed('/');
              },
              enableFeedback: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_filled,
                    size: navIconSize,
                  )
                ],
              ),
            ),
            MaterialButton(
              onPressed: () {
                Get.toNamed('/settings');
              },
              enableFeedback: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings,
                    size: navIconSize,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
