import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppPreferences {
  static late SharedPreferences prefs;

  static void init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUuid() async {
    String uuid = const Uuid().v4();
    await prefs.setString('uuid', uuid);
  }

  static String getUuid() {
    Object? o = prefs.get('uuid');
    if (o != null) {
      return o.toString();
    } else {
      setUuid();
    }

    return getUuid();
  }

  static Future<void> storeToken(String token) async {
    await prefs.setString('token', token);
  }

  static String? getToken(String token) {
    Object? o = prefs.get('token');
    if (o != null) {
      return o.toString();
    }

    return null;
  }
}
