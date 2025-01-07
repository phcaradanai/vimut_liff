import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xengistic_app/app/services/find_service.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';
import 'package:xengistic_app/app/services/master_service.dart';
import 'package:xengistic_app/app/services/profile_service.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    serviceUse.addAll(serviceTypeOns);
  }

  static ProfileController get to => Get.put(ProfileController());
  final ImagePicker picker = ImagePicker();

  get toDayJobs => JobsService.to.toDayJobs;

  get failJobs => JobsService.to.toDayFailJobs;
  get doneJobs => JobsService.to.toDayDoneJobs;

  get profile => ProfileService.to.profile;

  get serviceTypes => MasterService.to.getMsTable('serviceTypes');

  get canModiService => _isModifyService();

  get serviceTypeOns => profile?['config']?['porter']?['serviceTypeIds'] ?? [];

  RxList serviceUse = [].obs;

  _isModifyService() {
    List? projectSetting = MasterService.to.getMsTable('projectSettings');
    var modi = projectSetting
        ?.firstWhere((element) => element['code'] == 'modifyService');
    return modi?['value'] == 'Y' ? true : false;
  }

  logout() async => await ProfileService.to.logout();

  fetchUploadImageProfile(file) async =>
      await ProfileService.to.fetchUploadImageProfile(file);

  findUserPic(user) => FindService.to.findUserPic(user);

  findImageServiceType(serviceId) =>
      FindService.to.findImageServiceType(serviceId);
}
