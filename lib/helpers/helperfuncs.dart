import 'package:intl/intl.dart';

String time(date) {
  var dateValue = DateFormat("yyyy-MM-dd HH:mm:ss").parseUTC(date);
  String formattedDate = DateFormat("yyyy/MM/dd").format(dateValue);
  return formattedDate;
}
