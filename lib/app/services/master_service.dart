import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xengistic_app/api/main_provider.dart';
import 'package:xengistic_app/app/services/app_service.dart';

class MasterService extends GetxService {
  final _box = GetStorage();

  static MasterService get to => Get.put(MasterService());
  final _msTsKey = 'master.lastSync';

  var masterTs = [
    "markers",
    "projectSettings",
    "projects",
    "serviceCenters",
    "serviceTypes",
    "skills",
    "users"
  ];

  Future<void> setMsTable(String tableName, List<dynamic>? data) async {
    await _box.write(tableName, data);
  }

  List<dynamic>? getMsTable(String tableName) {
    return _box.read(tableName);
  }

  String? msTsKey() {
    return _box.read(_msTsKey);
  }

  Future<void> setMsTsKey(String? msTs) {
    return _box.write(_msTsKey, msTs);
  }

  Timer? msSyncing;
  setMsSyncing() {
    msSyncing = Timer.periodic(const Duration(seconds: 180), (timer) async {
      await fetchSyncMaster();
    });
  }

  Future<void> fetchSyncMaster() async {
    var api = await mainProvider();
    try {
      var body = {
        "tables": masterTs,
        "ts": _box.read(_msTsKey),
      };
      var res = await api.post(
        '/api/master/sync',
        data: body,
      );
      if (res.statusCode == 200) {
        var result = _Model.dataResponse(res.data);
        if (result.data != null) {
          var data = result.data;
          if (data!.containsKey('_ts')) {
            await _box.write(_msTsKey, data['_ts']);
            data.remove('_ts');
          }
          for (String name in data.keys) {
            if (name.startsWith('_')) {
              continue;
            }
            Map tableNew = {};
            tableNew = data[name];
            if (tableNew.containsKey('upd')) {
              List? tableOld = _box.read(name);
              List tableNewRows = tableNew['upd'];
              for (var element in tableNewRows) {
                int index =
                    tableOld!.indexWhere((data) => data['id'] == element['id']);
                if (index != -1) {
                  tableOld.removeAt(index);
                  tableOld.insert(index, element);
                } else {
                  if (kDebugMode) {
                    print('No negative integers found.');
                  }
                }
              }
              await _box.write(name, tableOld);
            } else if (tableNew.containsKey('ins')) {
              await _box.write(name, tableNew['ins']);
            }
          }
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

  Future<void> fetchGetImageUpload() async {
    var api = await mainProvider();

    try {
      var res = await api.get(
        '/api/upload/image-upload',
      );
      if (res.statusCode == 200) {
        var result = _Model.listResponse(res.data);
        if (result.list != null) {
          await AppService.to.setImageUpload(result.list);
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
}

class _Model {
  int? ok;
  String? token;
  String? error;
  Map<dynamic, dynamic>? data;
  List? list;

  _Model({this.ok, this.token, this.error, this.data, this.list});

  factory _Model.dataResponse(dynamic json) => _Model(
        ok: json["ok"],
        data: json["data"],
        token: json["token"],
        error: json["error"],
      );

  factory _Model.listResponse(dynamic json) => _Model(
        ok: json["ok"],
        list: json["data"],
        token: json["token"],
        error: json["error"],
      );
}
