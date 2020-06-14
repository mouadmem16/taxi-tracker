import 'dart:convert';
import 'dart:io';

import 'package:app/Utilities/ApiClient.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();
  String token;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Future<void> init() async {
    final SharedPreferences prefs = await _prefs;
    final key = 'device_info';
    final value = prefs.getString(key) ?? '{}';
    var deviceInfo = json.decode(value);
    if (deviceInfo['data'] != null) {
      if (deviceInfo['data']['device_token'] != null) {
        this.token = deviceInfo['data']['device_token'];
      }
    }

    if ( this.token=='') {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();
      // For testing purposes print the Firebase Messaging token
      this.token = await _firebaseMessaging.getToken();

      initPlatformState(token);
    }
  }

  Future<void> initPlatformState(token) async {
    try {
      if (Platform.isAndroid) {
        _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        _deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
      addDevice(token);
    } on PlatformException {
      _deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  Future addDevice(token) async {
    ApiClient apiLoader = new ApiClient();

    var body = <String, String>{
      'os': Platform.isAndroid ? 'Android' : 'iOS',
      'device_token': token,
      'device_details': json.encode(_deviceData),
    };
    var device = await apiLoader.post('/users/v1/device', body);

    _save(json.encode(device));
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  _save(String value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'device_info';
    prefs.setString(key, value);
  }
}
