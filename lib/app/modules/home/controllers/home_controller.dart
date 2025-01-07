import 'package:get/get.dart';
import 'package:xengistic_app/app/services/app_service.dart';
import 'package:xengistic_app/app/services/auth_service.dart';

import 'package:xengistic_app/app/services/find_service.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';
import 'package:xengistic_app/app/services/master_service.dart';
import 'package:xengistic_app/app/services/profile_service.dart';

class HomeController extends GetxController {
  HomeController get to => Get.put(HomeController());

  @override
  void onClose() {
    AppService.to.cancelTimer(AuthService.to.pinger);
    AppService.to.cancelTimer(AuthService.to.refresher);
    AppService.to.cancelTimer(MasterService.to.msSyncing);
    AppService.to.cancelTimer(JobsService.to.jobSyncing);

    super.onClose();
  }

  Map get profile => ProfileService.to.profile;
  get photoProfile => profile['config']?['photoProfile'];

  List get activeJobs => JobsService.to.activeJobs;
  List get doneJobs => JobsService.to.doneJobs;

  findImageServiceType(serviceId) =>
      FindService.to.findImageServiceType(serviceId);
  findServiceType(serviceId) => FindService.to.findServiceType(serviceId);
  findMarker(markerId) => FindService.to.findMarker(markerId);
  findUserPic(user) => FindService.to.findUserPic(user);
  findUser(userId) => FindService.to.findUser(userId);
}
