import 'package:intl/intl.dart';

String formatDateTimeComplete(DateTime dateTime) {
  return DateFormat.yMd().add_jm().format(dateTime);
}
