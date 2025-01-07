import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:xengistic_app/api/main_provider.dart';
import 'package:xengistic_app/app/services/auth_service.dart';
import 'package:xengistic_app/app/services/mqtt_service.dart';

class ProfileService extends GetxService {
  final _box = GetStorage();

  static ProfileService get to => Get.put(ProfileService());
  final _authK = 'auth.data';

  bool get statusCheckIn => profile['info']?['porter']?['checkIn'] ?? false;
  RxMap profile = {}.obs;
  Future<void> setProfile(Map<dynamic, dynamic> data) async {
    profile.addAll(data);
    await _box.write('profile', data);
  }

  Future<void> fetchGetProfile() async {
    var api = await mainProvider();
    try {
      var res = await api.get('/api/auth/profile');
      if (res.statusCode == 200) {
        var result = _Model.profileResponse(res.data);
        if (result.data != null) {
          await _box.write(_authK, result.data);
          await setProfile(result.data?['profile'] ?? {});
          await _box.write('mqtt', result.data?['mqtt']);
          // await MqttService.to.connectToMqtt();
          SharedPreferences preferences = await SharedPreferences.getInstance();
          var deviceToken = preferences.getString('deviceToken');
          try {
            await api.post(
              '/api/user/device-token',
              data: {"deviceToken": deviceToken},
            );
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
          AuthService.to.isLoggedIn.value = true;
        }
      } else if (res.statusCode == 401) {
        Get.offAllNamed('/sign-in');
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

      // return Future.error('Unexpected error 😢');
    }
  }

  Future<void> fetchUploadImageProfile(XFile? file) async {
    if (file == null) {
      return;
    }
    var api = await mainProvider();

    try {
      var profile = _box.read('profile');
      var body = FormData({
        'file': MultipartFile(await file.readAsBytes(),
            filename: file.name, contentType: 'image/jpeg'),
        'id': profile['id'],
        'photoId': profile['config']['photoId'],
      });

      var res = await api.post(
        '/api/user/update-photo-profile',
        data: body,
        options: dio.Options(contentType: 'multipart/form-data'),
      );
      if (res.statusCode == 200) {
        await _box.write('photo.profile', profile['config']['photoProfile']);
        Get.snackbar(
          "Process success",
          "Upload image profile.",
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

  Future<void> logout() async {
    var api = await mainProvider();

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var deviceToken = preferences.getString('deviceToken');
      var data = {
        "info": {
          "porter": {
            "online": false,
            "checkIn": false,
          },
        },
        "deviceToken": deviceToken
      };
      var res = await api.post(
        '/api/porter/check-out',
        data: data,
      );

      if (res.statusCode == 200) {
        // MqttService.to.client.unsubscribe('p/#');
        // MqttService.to.client.unsubscribe('u/#');
        // await Workmanager().cancelAll();
        MqttService.to.client.disconnect();
        AuthService.to.isLoggedIn.value = false;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove('token');
        _box.remove('token');
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

  Future<void> checkOut(remark) async {
    var api = await mainProvider();

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var deviceToken = preferences.getString('deviceToken');
      var data = {
        "info": {
          "remark": remark ?? '',
          "durationMinute": 0,
        },
        "deviceToken": deviceToken
      };
      var res = await api.post(
        '/api/porter/check-out',
        data: data,
      );

      if (res.statusCode == 200) {
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

  Future<void> checkIn() async {
    var api = await mainProvider();

    try {
      var res = await api.get(
        '/api/porter/check-in',
      );

      if (res.statusCode == 200) {
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

  factory _Model.profileResponse(dynamic json) => _Model(
        ok: json["ok"] ?? '',
        data: json["data"] ?? <dynamic, dynamic>{},
        token: json["token"] ?? '',
        error: json["error"] ?? '',
      );
}
