import 'package:intl/intl.dart';

String time_left_until_a_specific_date(String startDate, String endDate1) {
  final startDateObj = DateFormat("d MMM y").parse(startDate);
  final endDate = DateFormat("d MMM y").parse(endDate1);
  final now = DateTime.now();

  if (startDateObj.isAfter(now)) {
    return "Hasn't begun yet";
  } else {
    final daysLeft = endDate.difference(now).inDays;
    if (daysLeft < 0) {
      return "Overdue by ${daysLeft.abs()} days";
    } else if (daysLeft == 0) {
      return "Due today";
    } else {
      return "$daysLeft days left";
    }
  }
}
