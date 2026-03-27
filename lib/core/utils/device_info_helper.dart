import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoHelper {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<String> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfoPlugin.androidInfo;
        return 'Android | ${info.brand} | ${info.model} | Android ${info.version.release}';
      }

      if (Platform.isIOS) {
        final info = await _deviceInfoPlugin.iosInfo;
        return 'iOS | ${info.utsname.machine} | iOS ${info.systemVersion}';
      }

      return Platform.operatingSystem;
    } catch (_) {
      return 'Unknown Device';
    }
  }
}
