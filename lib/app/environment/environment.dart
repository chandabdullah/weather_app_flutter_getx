import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  // const String BASE_URL = "api.uzimate.com";
  static String BASE_URL = dotenv.env["DB_URL"] ?? "";
  static String API_KEY = dotenv.env["API_KEY"] ?? "";
}
