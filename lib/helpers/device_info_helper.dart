import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:userportal/models/device_model.dart';
import 'package:web_browser_detect/web_browser_detect.dart';

class DeviceInfoHelper {
  static Future<DeviceModel> getDeviceInfo() async {
    DeviceModel device = DeviceModel.empty();

    try {
      Browser? b = Browser.detectOrNull();
      DeviceInfoPlugin plugin = DeviceInfoPlugin();

      device.applicationType = kIsWeb ? 'BROWSER' : 'APK';
      device.devicePlatform = getDevicePlatform();

      if (kIsWeb && b != null) {
        device.browser = b.browser;
        device.browserVersion = b.version;
      } else {
        if (isAndroid) {
          final AndroidDeviceInfo di = await plugin.androidInfo;
          device.deviceVersion = di.version.release;
          device.deviceBrand = di.brand;
          device.deviceModel = di.model;
        } else if (isiOS) {
          final IosDeviceInfo di = await plugin.iosInfo;
          device.deviceVersion = di.systemVersion;
          device.deviceBrand = 'APPLE';
          device.deviceModel = di.model;
        }
      }
    } catch (e) {
      //
    }

    return device;
  }

  static bool get isWindowsPlatform => defaultTargetPlatform == TargetPlatform.windows;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isiOS => defaultTargetPlatform == TargetPlatform.iOS;
  static bool get ismacOs => defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;
  static bool get isFuchsia => defaultTargetPlatform == TargetPlatform.fuchsia;

  static String getDevicePlatform() {
    if (isWindowsPlatform) {
      return "WINDOWS";
    } else if (isAndroid) {
      return "ANDROID";
    } else if (isiOS) {
      return "iOS";
    } else if (ismacOs) {
      return "macOS";
    } else if (isLinux) {
      return "LINUX";
    } else if (isFuchsia) {
      return "FUCHSIA";
    }
    return "UNKNOWN_PLATFORM";
  }
}
