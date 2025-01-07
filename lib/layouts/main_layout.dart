import 'package:flutter/material.dart';

import 'package:xengistic_app/app/services/auth_service.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';
import 'package:xengistic_app/app/services/master_service.dart';
import 'package:xengistic_app/layouts/mobile_scafold.dart';
import 'package:xengistic_app/layouts/tablet_scafold.dart';

class MainLayout extends StatelessWidget {
  final Widget childOutlet;

  initializeSettings() async {
    await Future.delayed(const Duration(seconds: 1));

    await JobsService.to.fetchGetJob(
      statusJob: 1,
    );
    await JobsService.to.fetchGetJob(
      statusJob: 0,
    );
    AuthService.to.setPingPong();
    AuthService.to.setRefresher();
    MasterService.to.setMsSyncing();
    JobsService.to.setJobSyncing();
  }

  const MainLayout({
    super.key,
    required this.childOutlet,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingView();
        } else {
          if (snapshot.hasError) {
            return errorView(snapshot);
          } else {
            return LayoutBuilder(builder: (context, contraints) {
              if (contraints.maxWidth < 500) {
                return MobileScaffold(childOutlet: childOutlet);
              } else {
                return TabletScaffold(childOutlet: childOutlet);
              }
            });
          }
        }
      },
    );
  }

  Scaffold errorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
  }

  Scaffold waitingView() {
    return const Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
            Text('Processing...'),
          ],
        ),
      ),
    ));
  }
}
