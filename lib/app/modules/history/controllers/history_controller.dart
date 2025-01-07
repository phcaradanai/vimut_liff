import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xengistic_app/app/services/find_service.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';

class HistoryController extends GetxController {
  @override
  onInit() {
    super.onInit();
    myDate.addAll(_isMyDate());
    setFocusNode();
  }

  final ScrollController scrollController = ScrollController();

  List get doneJobs => JobsService.to.doneJobs;

  List<dynamic> get getAgo7Days => _getAgo7Days();

  List get jobAllInMyDate => _jobAllInMyDate();

  List<FocusNode> focusNodes = [];

  RxMap myDate = {}.obs;

  findServiceType(serviceId) => FindService.to.findServiceType(serviceId);

  findJobEvents(jobId) => FindService.to.findJobEvents(jobId);

  findTimeLine(selectJob) => FindService.to.findTimeLine(selectJob);

  setFocusNode() {
    focusNodes = List.generate(getAgo7Days.length, (_) => FocusNode());
    for (var element in focusNodes) {
      element.addListener(() => scrollToButton(element));
    }
  }

  scrollToButton(FocusNode buttonFocusNode) {
    if (buttonFocusNode.hasFocus) {
      scrollController.animateTo(
        buttonFocusNode.offset.dx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  _jobAllInMyDate() {
    var jobs = doneJobs.where((element) {
      return DateFormat('EEE,MMM,d')
          .format(DateTime.parse(element['ts']))
          .contains(myDate.values.join(','));
    });

    return jobs.toList();
  }

  _isMyDate() {
    final now = DateTime.now();
    List dateData = DateFormat('EEE,MMM,d').format(now).split(',').toList();
    return {
      'day': dateData[0],
      'month': dateData[1],
      'date': dateData[2],
    };
  }

  _getAgo7Days() {
    final now = DateTime.now();
    List<dynamic> days = [];
    for (int i = 0; i < 7; i++) {
      final nextDay = now.add(Duration(days: -i));
      List dateData =
          DateFormat('EEE,MMM,d').format(nextDay).split(',').toList();
      days.insert(
        0,
        {
          'day': dateData[0],
          'month': dateData[1],
          'date': dateData[2],
        },
      ); // Format: Mon, Jan 1
    }
    return days;
  }
}
