import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:xengistic_app/app/routers/app_pages.dart';
import 'package:xengistic_app/app/services/app_service.dart';

import 'package:xengistic_app/app/services/auth_service.dart';
import 'package:xengistic_app/app/services/master_service.dart';
import 'package:xengistic_app/app/services/profile_service.dart';
import 'package:xengistic_app/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("message:$message");
  }
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

Future<void> main() async {
  await initializeService();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: Future.sync(
      () async {
        await isHaveToken();
      },
    ), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Obx(
        () => GetMaterialApp(
          builder: (context, child) {
            Widget error = const Text('...rendering error...');
            if (child is Scaffold || child is Navigator) {
              error = Scaffold(
                body: Center(
                  child: error,
                ),
              );
            }
            ErrorWidget.builder = (errorDetails) => error;
            if (child != null) return child;
            throw StateError('widget is null');
          },
          debugShowCheckedModeBanner: false,
          fallbackLocale: const Locale('th', 'TH'),
          title: 'XENGISTIC',
          theme: ThemeData(
              colorSchemeSeed: AppService.to.primaryColor.value,
              useMaterial3: true,
              brightness: AppService.to.isDarkMode.value
                  ? Brightness.dark
                  : Brightness.light),
          // home: MainLayout(
          //   childOutlet: HomeView(),
          // ),
          locale: Get.deviceLocale,
          initialRoute: AppPages.initial,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
          getPages: AppPages.routes,
        ),
      );
    });
  }
}

//certificate
class MyHttpOverrides extends HttpOverrides {
  // This should be used while in development mode,
  //do NOT do this when you want to release to production,
  //the aim of this answer is to make the development a bit easier for you, for production,
  //you need to fix your certificate issue and use it properly,
  //look at the other answers for this as it might be helpful for your case.
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
//--certificate

//background worker
Future<void> initializeService() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }

  HttpOverrides.global = MyHttpOverrides();

  // final notificationSettings =
  await FirebaseMessaging.instance.requestPermission(provisional: true);
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (GetPlatform.isAndroid) {
    String? fcmToken = '';
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      Get.snackbar(
        "Process failed",
        "failed: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      exit(-1);
    }
    if (kDebugMode) {
      print("tokenDeviceAndroid:$fcmToken");
    }
    if (fcmToken != '') {
      await preferences.setString('deviceToken', fcmToken ?? '');
    }
  }
  if (GetPlatform.isIOS) {
    String? tokenApn;
    try {
      tokenApn = await FirebaseMessaging.instance.getAPNSToken();
    } catch (e) {
      Get.snackbar(
        "Process failed",
        "failed: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      exit(-1);
    }

    if (kDebugMode) {
      print("tokenApn:$tokenApn");
    }
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print("tokenDeviceIos:$fcmToken");
    }
    if (tokenApn != null) {
      await preferences.setString('deviceToken', fcmToken ?? '');
    }
  }
  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp
      .listen(_firebaseMessagingBackgroundHandler);
}
//--entry-background

//===>deviceId

isHaveToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.get('token');
  if (kDebugMode) {
    print("token==>$token");
  }
  if (token != null || token != '') {
    AuthService.to.isLoggedIn.value = true;
    await ProfileService.to.fetchGetProfile();
    await MasterService.to.fetchSyncMaster();
    await MasterService.to.fetchGetImageUpload();
  }
}
