import 'package:intl/intl.dart';

String dateParser(var date) {
  if (date is String) {
    return DateFormat('d MMM y').format(DateTime.parse(date));
  }
  return DateFormat('d MMM y').format(date);
}
