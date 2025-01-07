import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xengistic_app/app/modules/jobs/controllers/jobs_controller.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';
import 'package:xengistic_app/config.dart';

class JobDetailController extends GetxController {
  final String jobId;

  JobDetailController(this.jobId);

  JobDetailController get to => Get.put(JobDetailController(jobId));
  JobsController get jobCtrl => Get.put(JobsController());

  get selectJob => JobsService.to.selectedJob;
  get confirmBy =>
      selectJob['config']['serviceTypeConfig']['confirm']
          [jobCtrl.findNextStatus(selectJob).toString().toLowerCase()]?['by'] ??
      'porter';

  get photoConfirm =>
      selectJob['config']['serviceTypeConfig']['confirm']
              [jobCtrl.findNextStatus(selectJob).toString().toLowerCase()]
          ?['photo'] ??
      false;

  get isPorterConfirm => _isPorterConfirm();

  _isPorterConfirm() {
    return confirmBy == 'porter' && photoConfirm == true;
  }

  isRightEvent(eventType) {
    return jobCtrl.findNextStatus(selectJob).toString() == eventType;
  }

  srcEventImage(eventType) {
    var src = selectJob?['info']?['photoPaths']?[eventType];
    Image? pic;
    src != null
        ? pic = Image.network(
            appConfig['API_URL'] + src,
            fit: BoxFit.contain,
          )
        : pic = null;
    return pic;
  }
  // findMarker(markerId) => FindService.to.findMarker(markerId);

  // findUserPic(user) => FindService.to.findUserPic(user);

  // findUser(userId) => FindService.to.findUser(userId);

  // findNextStatus(selectJob) => FindService.to.findNextStatus(selectJob);
}
