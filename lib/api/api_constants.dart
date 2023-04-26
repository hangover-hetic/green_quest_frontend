import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String env = dotenv.get('GREEN_QUEST_ENV');
  static String greenQuest = ApiConstants.env == 'PROD'
      ? dotenv.get('GREEN_QUEST_URL_PROD')
      : dotenv.get('GREEN_QUEST_URL_LOCAL');
}
