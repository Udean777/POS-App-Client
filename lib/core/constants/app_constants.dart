import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConstants {
  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return "http://10.0.2.2:8080/api/v1";
    }
    return "http://localhost:8080/api/v1";
  }

  static const String appName = 'Modal POS';

  static const String tokenKey = 'jwt_token';
  static const String userKey = 'user_data';
}
