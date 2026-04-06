import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConstants {
  static String get baseUrl {
    // Android emulator uses 10.0.2.2 to access localhost of the host machine
    if (!kIsWeb && Platform.isAndroid) {
      return "http://10.0.2.2:8080/api/v1";
    }
    // iOS simulator and Web can use localhost/127.0.0.1
    return "http://localhost:8080/api/v1";
  }
  static const String appName = 'POS App';

  static const String tokenKey = 'jwt_token';
  static const String userKey = 'user_data';
}
