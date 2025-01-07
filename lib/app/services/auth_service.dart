import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xengistic_app/api/main_provider.dart';
import 'package:xengistic_app/app/services/master_service.dart';
import 'package:xengistic_app/app/services/profile_service.dart';
import 'package:xengistic_app/config.dart';

final pjCode = appConfig['PROJECT_CODE'];

class AuthService extends GetxService {
  final _box = GetStorage();

  static AuthService get to => Get.put(AuthService());

  RxBool isLoggedIn = false.obs;

  bool get isLoggedInValue => isLoggedIn.value;
  RxString token = ''.obs;

  Future<void> setToken(String tk) async {
    token.value = tk;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', tk);
    await _box.write('token', tk);
  }

  Timer? pinger;
  Timer? refresher;
  setPingPong() {
    pinger = Timer.periodic(const Duration(seconds: 60), (timer) async {
      await pingPong();
    });
  }

  setRefresher() {
    refresher = Timer.periodic(const Duration(seconds: 60), (timer) async {
      await refreshToken();
    });
  }

  Future<void> refreshToken() async {
    var api = await mainProvider();
    try {
      await api.get(
        '/api/auth/token',
      );
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

  Future<void> pingPong() async {
    var api = await mainProvider();

    try {
      var statusCheckIn = ProfileService.to.statusCheckIn;
      await api.post(
        '/api/porter/ping',
        data: {
          "checkIn": statusCheckIn,
        },
      );
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

  Future<void> signin(String username, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var api = await mainProvider();
    try {
      if (username.isNotEmpty && password.isNotEmpty) {
        var body = Model(
                projectCode: pjCode,
                username: username,
                passwordHash: md5
                    .convert(utf8.encode("$pjCode$username$password"))
                    .toString())
            .signinBodyToJson();
        var res = await api.post(
          '/api/auth/signin',
          data: body,
        );
        if (res.statusCode == 200) {
          var result = Model.signInResponse(res.data);
          if (result.ok == 1) {
            await preferences.setString('token', result.token ?? '');
            await setToken(result.token ?? '');
            await ProfileService.to.fetchGetProfile();
            await MasterService.to.fetchSyncMaster();
            await MasterService.to.fetchGetImageUpload();
            Get.offNamed("/");
          } else {
            Get.snackbar(
              "Process failed",
              "failed: ${result.e}",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          var resMsg = res.data == null ? res.statusMessage : res.data.message;
          Get.snackbar(
            "Process failed",
            resMsg ?? "failed: $res",
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

class Model {
  int? ok;
  String? token;
  String? e;
  String? username;
  String? projectCode;
  String? passwordHash;

  Model({
    this.ok,
    this.e,
    this.token,
    this.username,
    this.projectCode,
    this.passwordHash,
  });

  Map<String, dynamic> signinBodyToJson() => {
        "projectCode": projectCode,
        "username": username,
        "passwordHash": passwordHash,
      };

  factory Model.signInResponse(dynamic json) => Model(
        ok: json["ok"] ?? '',
        token: json["token"] ?? '',
        e: json["error"] ?? '',
      );
}
