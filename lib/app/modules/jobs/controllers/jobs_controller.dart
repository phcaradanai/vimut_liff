import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xengistic_app/app/services/find_service.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';

class JobsController extends GetxController {
  JobsController get to => Get.put(JobsController());

  List get serviceTypes => _box.read('serviceTypes');
  final _box = GetStorage();
  List get allJob => JobsService.to.allJob;
  get selectJob => JobsService.to.selectedJob;
  Map get jobLengthByService => JobsService.to.jobLengthByService;
  get colors => JobsService.to.colors;
  List get doneJobs => JobsService.to.doneJobs;
  List get activeJobs => JobsService.to.activeJobs;
  RxBool busy = false.obs;

  RxMap searchBox = {}.obs;

  Rx touchedIndex = 0.obs;
  RxList filteredJobs = [].obs;

  filterAllData() {
    var data = [];
    switch (selectedCategory.value) {
      case 'a':
        data = filterJobs(allJob);
      case 'o':
        data = filterJobs(activeJobs);
      case 'c':
        data = filterJobs(doneJobs);
    }

    filteredJobs.value = data;
    filteredJobs.refresh();
  }

  filterJobs(List jobs) {
    if (searchBox.isNotEmpty) {
      return jobs
          .where((element) =>
              element['config']['form']['serviceTypeId'] == searchBox['id'])
          .toList();
    } else {
      return jobs;
    }
  }

  List category = [
    {
      'code': 'a',
      'text': 'ALL',
    },
    {
      'code': 'o',
      'text': 'ON DUTY',
    },
    {
      'code': 'c',
      'text': 'COMPLETED',
    },
  ];

  Rx selectedCategory = 'a'.obs;

  findMarker(markerId) => FindService.to.findMarker(markerId);

  findUserPic(user) => FindService.to.findUserPic(user);

  findUser(userId) => FindService.to.findUser(userId);

  findNextStatus(selectJob) => FindService.to.findNextStatus(selectJob);

  findTimeLine(selectJob) => FindService.to.findTimeLine(selectJob);

  findImageServiceType(serviceId) =>
      FindService.to.findImageServiceType(serviceId);

  findServiceType(serviceId) => FindService.to.findServiceType(serviceId);

  findImageCheckList(checkListCode, selectJob) =>
      FindService.to.findImageCheckList(checkListCode, selectJob);

  findImageByCode(code) => FindService.to.findImageByCode(code);

  cancelJob(selectJob) => JobsService.to.cancelJob(selectJob);

  updateJob(selectJob) => JobsService.to.updateJob(selectJob);
}
