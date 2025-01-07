import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';
import 'package:xengistic_app/config.dart';

class FindService extends GetxService {
  final _box = GetStorage();

  static FindService get to => Get.put(FindService());

  findMarker(markerId) {
    var markers = _box.read('markers');
    return markers.firstWhere((element) => element['id'] == markerId,
        orElse: () => null);
  }

  findUser(userId) {
    var users = _box.read('users');
    return users.firstWhere(
      (element) => element['id'].toString() == userId.toString(),
      orElse: () => null,
    );
  }

  findUserPic(user) {
    return user?['config']?['photoProfile'] != null
        ? Image.network(
            appConfig['API_URL'] + user?['config']?['photoProfile'],
            fit: BoxFit.contain,
          )
        : Image.asset(
            'assets/company/logo.png',
            fit: BoxFit.contain,
          );
  }

  findNextStatus(selectJob) {
    var currentStatus = selectJob['info']['lastEvent']['eventType'];
    Map<String, String>? mapStatus = {
      "ACCEPT": 'START',
      "START": 'PICKUP',
      "PICKUP": 'DROPOFF',
      "DROPOFF": 'DONE',
    };

    var nextStatus = mapStatus.entries.firstWhere(
        (element) => element.key == currentStatus,
        orElse: () => const MapEntry("", ""));

    return nextStatus.value;
  }

  findTimeLine(selectJob) {
    var now = [];
    List<dynamic> timeline = [
      {"title": 'ACCEPT', "color": Colors.orange, "icon": Icons.my_location},
      {"title": 'CANCELLED', "color": Colors.red, "icon": Icons.cancel},
      {"title": 'START', "color": Colors.blue, "icon": Icons.directions_run},
      {"title": 'PICKUP', "color": Colors.cyan, "icon": Icons.inventory},
      {"title": 'DROPOFF', "color": Colors.green, "icon": Icons.where_to_vote},
    ];
    List<dynamic> jobEvents = selectJob['jobEvents'];
    for (Map<dynamic, dynamic> tl in timeline) {
      var eventType = jobEvents.firstWhere(
          (element) => element['eventType'] == tl['title'],
          orElse: () => null);

      if (eventType != null) {
        tl['ts'] = DateFormat('hh:mm').format(
          DateTime.parse(eventType['ts']),
        );
        tl['oriTs'] = eventType['ts'];
        now.add(tl);
      }
    }
    now.sort(
      (a, b) => DateTime.parse(a['oriTs']).compareTo(
        DateTime.parse(
          b['oriTs'],
        ),
      ),
    );
    return now;
  }

  findImageServiceType(serviceId) {
    var imageUpload = _box.read('image.upload');
    List serviceTypes = _box.read('serviceTypes');
    var serviceTypeIcon = serviceTypes.firstWhere(
        (element) => element['id'] == serviceId,
        orElse: () => null);

    if (serviceTypeIcon != null) {
      serviceTypeIcon = serviceTypeIcon['config']['icon'];
    }
    var pic = imageUpload.isNotEmpty
        ? imageUpload.firstWhere((element) => element?['id'] == serviceTypeIcon,
            orElse: () => null)
        : null;

    return pic != null
        ? Image.network(
            appConfig['API_URL'] + pic?['path'],
            fit: BoxFit.contain,
          )
        : Image.asset(
            'assets/company/logo.png',
            fit: BoxFit.contain,
          );
  }

  findServiceType(serviceId) {
    var serviceTypes = _box.read('serviceTypes');
    return serviceTypes.firstWhere((element) => element['id'] == serviceId);
  }

  Image findImageCheckList(clCode, selectJob) {
    if (clCode == null) {
      return Image.asset(
        'assets/company/logo.png',
        fit: BoxFit.contain,
      );
    }
    var imageUpload = _box.read('image.upload');
    var imageCheckList =
        imageUpload.where((element) => element['info']['checkList'] == true);
    List<dynamic> checkList =
        selectJob['config']['serviceTypeConfig']['checkList'] ?? [];
    var selectCl = checkList.firstWhere(
      (a) => a['value'] == clCode,
      orElse: () => null,
    );
    if (selectCl == null) {
      return Image.asset(
        'assets/company/logo.png',
        fit: BoxFit.contain,
      );
    }
    var pic = imageCheckList.firstWhere(
      (element) => element['id'] == selectCl['icon'],
      orElse: () => null,
    )?['path'];

    return pic != null
        ? Image.network(appConfig['API_URL'] + pic, fit: BoxFit.contain)
        : Image.asset(
            'assets/company/logo.png',
            fit: BoxFit.contain,
          );
  }

  findImageByCode(code) {
    var roundRows = [
      {
        "code": 'oneWay',
        "name": 'destination01',
      },
      {
        "code": 'roundTrip',
        "name": 'destination02',
      },
    ];
    var cautionRows = [
      {
        "code": 'noPrecaution',
        "name": 'caution01',
      },
      {
        "code": 'contact',
        "name": 'caution02',
      },
      {
        "code": 'airBorne',
        "name": 'caution03',
      },
    ];
    var speedRows = [
      {
        "code": 'normal',
        "name": 'speed01',
      },
      {
        "code": 'hurry',
        "name": 'speed02',
      },
      {
        "code": 'urgent',
        "name": 'speed03',
      },
    ];
    var codes = [...speedRows, ...cautionRows, ...roundRows];
    var selected = codes.firstWhere((element) => element['code'] == code,
        orElse: () => {});
    if (selected.isEmpty) {
      return;
    }
    var imageUpload = _box.read('image.upload');
    var pic = imageUpload.firstWhere(
      (element) => element['fileName'] == selected['name'],
      orElse: () => null,
    )?['path'];

    return pic != null
        ? Image.network(appConfig['API_URL'] + pic, fit: BoxFit.contain)
        : Image.asset(
            'assets/company/logo.png',
            fit: BoxFit.contain,
          );
  }

  List<dynamic>? findJobEvents(jobId) {
    return _box.read('jobEvents.$jobId') ?? [];
  }

  findActiveJobs(jobId) async {
    List activeJobs = JobsService.to.activeJobs;
    Map<dynamic, dynamic>? job = activeJobs
        .firstWhere((element) => element['id'] == jobId, orElse: () => null);
    if (job == null) {
      return null;
    }
    await JobsService.to.setSelectedJob(job);
  }

  findDoneJobs(jobId) async {
    var doneJobs = JobsService.to.doneJobs;

    Map<dynamic, dynamic>? job = doneJobs
        .firstWhere((element) => element['id'] == jobId, orElse: () => null);

    if (job == null) {
      return null;
    }
    await JobsService.to.setSelectedJob(job);
  }
}
