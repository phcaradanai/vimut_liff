import 'dart:convert';

import 'package:dio/dio.dart';
// import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xengistic_app/app/services/auth_service.dart';
import 'package:xengistic_app/config.dart';

final box = GetStorage();

// class MainProvider extends GetConnect {
//   static MainProvider get to => Get.put(MainProvider());

//   @override
//   void onInit() {
//     super.onInit();
//     httpClient.baseUrl = appConfig['API_URL'];

//     httpClient.addRequestModifier((Request request) {
//       request.headers['Accept'] = '*/*';
//       return request;
//     });
//     httpClient.addResponseModifier((Request request, dynamic response) async {
//       print("request ${request.url}");

//       print("response ${response.statusCode}");
//       final resObj = response.body;
//       if (response.statusCode == 401) {
//         AuthService.to.isLoggedIn.value = false;
//         AuthService.to.isLoggedIn.refresh();
//       }
//       if (resObj.containsKey('token') && resObj['token'].isNotEmpty) {
//         SharedPreferences preferences = await SharedPreferences.getInstance();
//         await preferences.setString('token', resObj['token']);
//         await box.write('token', resObj['token']);
//       }
//       return response;
//     });
//     httpClient.addAuthenticator((Request request) async {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       final token = preferences.getString('token');
//       request.headers['Authorization'] = "Bearer $token";
//       return request;
//     });
//     httpClient.maxAuthRetries = 3;
//   }
// }

Future<Dio> mainProvider() async {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: appConfig['API_URL'],
    ),
  );
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString('token');
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers = {
          'Authorization': "Bearer $token",
        };
        return handler.next(options);
      },
      onResponse: (response, ResponseInterceptorHandler handler) async {
        final resObj = response.data;
        if (resObj.containsKey('token') && resObj['token'].isNotEmpty) {
          await preferences.setString('token', resObj['token']);
          await box.write('token', resObj['token']);
        }

        return handler.next(response);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          AuthService.to.isLoggedIn.value = false;
          AuthService.to.isLoggedIn.refresh();
          // const RouteSettings(name: '/sign-in');
          // print("RouteSettings");
        }
        return handler.next(error);
      },
    ),
  );
  return dio;
}

class Model {
  Model({required this.ok, this.data, this.token, this.error});

  final int ok;
  final Map? data;
  final String? token;
  final String? error;

  factory Model.fromRawJson(String? str) =>
      Model.fromJson(json.decode(str!) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        ok: json["ok"] as int,
        data: json["data"],
        token: json["token"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "ok": error,
        "data": data,
        "token": token,
        "error": error,
      };
}
