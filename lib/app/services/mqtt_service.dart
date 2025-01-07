import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:xengistic_app/app/services/find_service.dart';
import 'package:xengistic_app/app/services/jobs_service.dart';
import 'package:xengistic_app/app/services/master_service.dart';
import 'package:xengistic_app/app/services/profile_service.dart';

class MqttService extends GetxService {
  static MqttService get to => Get.put(MqttService());
  final _box = GetStorage();
  var client = MqttServerClient('', '');

  final String mqttId = Random(DateTime.now().toUtc().millisecondsSinceEpoch)
      .nextInt(10000000)
      .toString();

  Future<dynamic> connectToMqtt() async {
    var mqttObj = _box.read('mqtt');

    client = MqttServerClient('${mqttObj['url']}', mqttId);
    try {
      client.useWebSocket = true;
      client.port = 443;

      client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;

      client.logging(on: false);

      client.setProtocolV311();

      client.keepAlivePeriod = mqttObj['options']['keepalive'];

      client.autoReconnect = true;

      client.onDisconnected = () {
        if (kDebugMode) {
          print('OnDisconnected client callback - Client disconnection');
        }
        if (client.connectionStatus!.disconnectionOrigin ==
            MqttDisconnectionOrigin.solicited) {
          if (kDebugMode) {
            print('OnDisconnected callback is solicited, this is correct');
          }
        }
      };

      client.onConnected = onConnected;

      client.onSubscribed = onSubscribed;

      client.pongCallback = pong;

      final profile = _box.read('profile');

      final connMess = MqttConnectMessage()
          .withClientIdentifier(mqttId)
          .withWillTopic(
              'p/${profile['projectId']}/porter/${profile['id']}/offline}') // If you set this you must set a will message
          .withWillMessage({
            'id': profile['id'],
          }.toString())
          .startClean() // Non persistent session for testing
          .withWillQos(MqttQos.atMostOnce)
          .authenticateAs(
              mqttObj['options']['username'], mqttObj['options']['password']);
      if (kDebugMode) {
        print('Mosquitto client connecting....');
      }
      client.connectionMessage = connMess;

      try {
        await client.connect();
      } on NoConnectionException catch (e) {
        if (kDebugMode) {
          print('client exception - $e');
        }
        client.disconnect();
        // exit(-1);
      } on SocketException catch (e) {
        if (kDebugMode) {
          print('socket exception - $e');
        }
        client.disconnect();
        // exit(-1);
      }

      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        if (kDebugMode) {
          print('Mosquitto client connected');
        }
      } else {
        if (kDebugMode) {
          print(
              'ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
        }
        client.disconnect();
        // exit(-1);
      }

      subUser(profile);
      subProject(profile);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return false;
    }
  }

  void onSubscribed(String topic) {
    // print('Subscription confirmed for topic $topic');
  }

  void onConnected() {
    if (kDebugMode) {
      print('OnConnected client callback - Client connection was successful');
    }
  }

  void pong() {
    if (kDebugMode) {
      print('Ping response client callback invoked');
    }
  }

  subUser(profile) {
    var topic = 'u/${profile['id']}/+';

    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      var subTopic = c[0].topic;
      if (kDebugMode) {
        print(
            'Change notification:: topic is <$subTopic>, payload is <-- $pt -->');
      }

      var resJson = jsonDecode(pt) as Map<String, dynamic>;
      if (subTopic.contains('u/${profile['id']}/job')) {
        if (['CANCELLED', 'DONE'].contains(resJson['status'])) {
          List activeJobs = JobsService.to.activeJobs;
          activeJobs.removeWhere((element) => element['id'] == resJson['id']);
        } else {
          List jobOld = JobsService.to.activeJobs;
          var newJobs = _mergeActiveJobs(jobOld, [resJson]);
          JobsService.to.setActiveJobs(newJobs);
        }

        await FindService.to.findActiveJobs(JobsService.to.selectedJob['id']);
      }

      if (subTopic.contains('u/${profile['id']}/profile')) {
        final userOld = ProfileService.to.profile;
        var userNew = _mergeMaps(userOld, resJson);
        await ProfileService.to.setProfile(userNew ?? {});
      }
    });
  }

  subProject(profile) {
    var topic = 'p/${profile['projectId']}/+';
    //p/project_id/+
    //j/project_id/user_id/porter_id
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      var subTopic = c[0].topic;

      if (kDebugMode) {
        print(
            'Change notification:: topic is <$subTopic>, payload is <-- $pt -->');
      }

      var resJson = jsonDecode(pt) as Map<String, dynamic>;
      if (subTopic.contains('p/${profile['projectId']}/master')) {
        for (var e in resJson.entries) {
          Map<dynamic, dynamic> mod = e.value;
          if (mod.containsKey('upd')) {
            var tbOld = MasterService.to.getMsTable(e.key);
            var tbNow = _mergeMsTable(tbOld, mod['upd']);
            await MasterService.to.setMsTable(e.key, tbNow);
          } else {
            await MasterService.to.setMsTable(e.key, mod['ins']);
          }
        }
      }
    });
  }

  Map<dynamic, dynamic>? _mergeMaps(
      Map<dynamic, dynamic>? map1, Map<dynamic, dynamic>? map2) {
    if (map1 == null) return map2;
    if (map2 == null) return map1;

    Map<dynamic, dynamic> result = Map.from(map1);

    map2.forEach((key, value) {
      if (result.containsKey(key) &&
          result[key] is Map &&
          value is Map<dynamic, dynamic>?) {
        result[key] = _mergeMaps(result[key], value);
      } else {
        result[key] = value;
      }
    });

    return result;
  }

  List<dynamic> _mergeMsTable(List<dynamic>? list1, List<dynamic>? list2) {
    List<dynamic> mergedList = [];

    int i = 0, j = 0;

    while (i < list1!.length && j < list2!.length) {
      if (list1[i]['id'].toString() == list2[j]['id'].toString()) {
        var nowList = _mergeMaps(list1[i], list2[j]);
        mergedList.add(nowList);
        i++;
        j++;
      } else {
        mergedList.add(list1[i]);
        i++;
      }
    }

    while (i < list1.length) {
      mergedList.add(list1[i]);
      i++;
    }

    while (j < list2!.length) {
      mergedList.add(list2[j]);
      j++;
    }

    return mergedList;
  }

  List<dynamic> _mergeActiveJobs(List<dynamic> list1, List<dynamic> list2) {
    List<dynamic> mergedList = [];

    int i = 0, j = 0;

    while (i < list1.length && j < list2.length) {
      if (list1[i]['id'].toString() == list2[j]['id'].toString()) {
        mergedList.add(list2[j]);
        i++;
        j++;
      } else {
        mergedList.add(list1[i]);
        i++;
      }
    }

    while (i < list1.length) {
      mergedList.add(list1[i]);
      i++;
    }

    while (j < list2.length) {
      mergedList.add(list2[j]);
      j++;
    }

    return mergedList;
  }
}
