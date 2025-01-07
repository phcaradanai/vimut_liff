import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:xengistic_app/api/main_provider.dart';
import 'package:xengistic_app/app/services/app_service.dart';
import 'package:xengistic_app/app/services/find_service.dart';

class JobsService extends GetxService {
  @override
  Future<void> onInit() async {
    super.onInit();
    setColors();
  }

  List colors = [].obs;

  static JobsService get to => Get.put(JobsService());
  final _box = GetStorage();
  final _sljKey = 'selected.job';
  final _atjKey = 'active.jobs';
  final _dnjKey = 'done.jobs';

  get toDayJobs => _toDayJobs();

  get toDayFailJobs => _toDayFailJobs();

  get toDayDoneJobs => _toDayDoneJobs();

  get allJob => [...activeJobs, ...doneJobs];

  RxList activeJobs = [].obs;
  RxList doneJobs = [].obs;

  RxMap selectedJob = {}.obs;

  Timer? jobSyncing;
  setJobSyncing() {
    jobSyncing = Timer.periodic(const Duration(seconds: 90), (timer) async {
      await fetchGetJob(statusJob: 1);
      await fetchGetJob(statusJob: 0);
    });
  }

  Future<void> setActiveJobs(newActiveJobs) async {
    activeJobs.assignAll(newActiveJobs);
    await _box.write(_atjKey, newActiveJobs);
  }

  Future<void> setDoneJobs(newActiveJobs) async {
    doneJobs.assignAll(newActiveJobs);
    await _box.write(_dnjKey, newActiveJobs);
  }

  Future<void> setJobEvents(var jobId, List? jbe) async {
    await _box.write('jobEvents.$jobId', jbe);
  }

  Future<void> setSelectedJob(selectJob) async {
    selectJob['jobEvents'] = await fetchGetJobEvents(selectJob['id']);
    selectedJob.addAll(selectJob);
    await _box.write(_sljKey, selectJob);
  }

  setColors() {
    var serviceTypes = _box.read('serviceTypes');
    colors.addAll(List.generate(serviceTypes.length, (i) {
      return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1);
    }));
  }

  _toDayJobs() {
    var allJobs = [...activeJobs, ...doneJobs]
        .where((element) =>
            DateFormat('yyyy-MM-dd').format(DateTime.parse(element['ts'])) ==
            DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .toList();
    return allJobs;
  }

  _toDayFailJobs() {
    return toDayJobs.where((element) => element['status'] == 'CANCELLED');
  }

  _toDayDoneJobs() {
    return toDayJobs.where((element) => element['status'] == 'DONE');
  }

  Map<dynamic, dynamic> get jobLengthByService => _jobLengthByService();

  Map<dynamic, dynamic> _jobLengthByService() {
    var allJob = [...activeJobs, ...doneJobs]
        .where((element) =>
            DateFormat('yyyy-MM-dd').format(DateTime.parse(element['ts'])) ==
            DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .toList();
    var groupServices = {};
    for (var j in allJob) {
      var serviceId = j?['config']?['form']?['serviceTypeId'] ?? -1;
      if (groupServices.containsKey(serviceId)) {
        groupServices[serviceId] += 1;
      } else {
        groupServices[serviceId] = 1;
      }
    }
    return groupServices;
  }

  Future fetchGetJob({required statusJob}) async {
    //statusJob 1 is active :: 2 is done
    var status = {
      "1": setActiveJobs,
      "0": setDoneJobs,
    };
    var api = await mainProvider();

    try {
      var res = await api.get(
        '/api/porter/jobs?active=$statusJob',
      );
      if (res.statusCode == 200) {
        var result = _Model.jobResponse(
          res.data,
        );
        if (result.data != null) {
          await status['$statusJob']!(result.data?['jobs']);
        } else {
          Get.snackbar(
            "Process failed",
            "failed: ${result.error}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.snackbar("Error", "Token is invalid or expired");
        await Future.delayed(
          Durations.short1,
          () {
            Get.offAllNamed('/sign-in');
          },
        );
      } else {
        return Future.error('${e.message}  \n Unexpected error 😢');
      }
    }
  }

  cancelJob(selectJob) async {
    if (selectJob.isEmpty) {
      return;
    }
    try {
      var status = 'CANCELLED';
      var body = {
        "jobId": selectJob['id'],
        "event": status,
        "status": status,
      };
      var api = await mainProvider();

      var res = await api.put(
        '/api/porter/job',
        data: body,
      );
      if (res.statusCode == 200) {
        Get.snackbar(
          "JOB TASK:${selectJob['id']}",
          "UPDATE STATUS TO CANCELLED SUCCESS.",
          messageText: const Text(
            "UPDATE STATUS TO CANCELLED SUCCESS.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Get.theme.cardColor,
          colorText: AppService.to.primaryColor.value,
        );
        _box.remove('selected.job');
        Get.offAndToNamed('/jobs');
      }
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.snackbar("Error", "Token is invalid or expired");
        await Future.delayed(
          Durations.short1,
          () {
            Get.offAllNamed('/sign-in');
          },
        );
      } else {
        return Future.error('${e.message}  \n Unexpected error 😢');
      }
    }
  }

  updateJob(selectJob) async {
    if (selectJob.isEmpty) {
      return;
    }
    try {
      var isCheckList = {};
      for (var list in selectJob['config']['checkList']) {
        isCheckList[list] = '';
      }
      var nextStatus = FindService.to.findNextStatus(selectJob);
      var status = 'START';
      if (nextStatus == 'DROPOFF') {
        status = 'DONE';
      }
      var body = {
        "jobId": selectJob['id'],
        "event": nextStatus,
        "status": status,
        "info": {
          "checkList": isCheckList,
        },
      };
      var api = await mainProvider();

      var res = await api.put(
        '/api/porter/job',
        data: body,
      );
      if (res.statusCode == 200) {
        Get.snackbar(
          "JOB TASK:${selectJob['id']}",
          "UPDATE STATUS TO $nextStatus SUCCESS.",
          messageText: Text(
            "UPDATE STATUS TO $nextStatus SUCCESS.",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Get.theme.cardColor,
          colorText: AppService.to.primaryColor.value,
        );
        if (status == 'DONE') {
          activeJobs.removeWhere((element) =>
              element['id'].toString() == selectJob['id'].toString());
          await _box.write('active.jobs', activeJobs);
          _box.remove('selected.job');
          Get.offAndToNamed('/jobs');
        }
      }
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.snackbar("Error", "Token is invalid or expired");
        await Future.delayed(
          Durations.short1,
          () {
            Get.offAllNamed('/sign-in');
          },
        );
      } else {
        return Future.error('${e.message}  \n Unexpected error 😢');
      }
    }
  }

  Future<dynamic> fetchGetJobEvents(jobId) async {
    var api = await mainProvider();

    try {
      var res = await api.get(
        '/api/job/job-events?jobId=$jobId',
      );
      if (res.statusCode == 200) {
        var result = _Model.jobResponse(res.data);
        if (result.data != null) {
          await setJobEvents(jobId, result.data?['jobEvents']);
          return result.data?['jobEvents'];
        } else {
          Get.snackbar(
            "Process failed",
            "failed: ${result.error}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
      return null;
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.snackbar("Error", "Token is invalid or expired");
        await Future.delayed(
          Durations.short1,
          () {
            Get.offAllNamed('/sign-in');
          },
        );
      } else {
        return Future.error('${e.message}  \n Unexpected error 😢');
      }
    }
  }

  Future<void> fetchUploadImageJobConfirm(XFile? file) async {
    if (file == null) {
      return;
    }
    try {
      var body = FormData({
        'file': MultipartFile(await file.readAsBytes(),
            filename: file.name, contentType: 'image/jpeg'),
        'id': selectedJob['id'],
        'nextEvt': FindService.to.findNextStatus(selectedJob),
      });
      var api = await mainProvider();

      var res = await api.post(
        '/api/porter/job-photo',
        data: body,
        options: dio.Options(
          contentType: 'multipart/form-data',
        ),
      );
      if (res.statusCode == 200) {
        Get.snackbar(
          "Process success",
          "Upload image job confirm.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Process failed",
          "failed: ${res.statusMessage}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.snackbar("Error", "Token is invalid or expired");
        await Future.delayed(
          Durations.short1,
          () {
            Get.offAllNamed('/sign-in');
          },
        );
      } else {
        return Future.error('${e.message}  \n Unexpected error 😢');
      }
    }
  }
}

class _Model {
  int? ok;
  String? token;
  String? error;
  Map<dynamic, dynamic>? data;

  _Model({
    this.ok,
    this.token,
    this.error,
    this.data,
  });

  factory _Model.jobResponse(dynamic json) => _Model(
        ok: json["ok"] ?? '',
        data: json["data"] ?? {},
        token: json["token"] ?? '',
        error: json["error"] ?? '',
      );
}
