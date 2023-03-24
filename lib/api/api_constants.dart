import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String testUrl = dotenv.get('TEST_API_URL');
}
