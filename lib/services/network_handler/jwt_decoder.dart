import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:userportal/services/network_handler/app_preferences.dart';

class jwtDecoder {
  Map<String, dynamic> getToken() {
    String? jsonToken = AppPreferences.getToken('token');
    if (jsonToken != null) {
      if (jsonToken == null) return {};
      var isExpired = JwtDecoder.isExpired(jsonToken);
      if (isExpired)
        return {};
      else
        return JwtDecoder.decode(jsonToken);
    }
    return {};
  }

  void ClearUser() {
    AppPreferences.prefs.clear();
  }
}
