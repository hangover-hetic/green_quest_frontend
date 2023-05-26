import 'api_constants.dart';

String extractIdFromUrl(String url) {
  return url.split('/').last;
}

String? getMediaUrl(String? url) {
  return url != null ? ApiConstants.greenQuest + url : null;
}

double toDouble(dynamic v) {
  if (v is double) {
    return v;
  }
  if (v is int) {
    return v.toDouble();
  }
  if (v is String) {
    return double.parse(v);
  }
  return 0;
}
