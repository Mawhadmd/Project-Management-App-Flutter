import 'package:flutter/material.dart';

String getStatusText(String status) {
  switch (status) {
    case "completed":
      return "Completed";
    case "inProgress":
      return "In Progress";
    case "onHold":
      return "On Hold";
    case "cancelled":
      return "Cancelled";
    default:
      return "Not Started";
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case "completed":
      return Colors.green.shade700;
    case "inProgress":
      return Colors.orange.shade700;
    case "onHold":
      return Colors.blue.shade700;
    case "cancelled":
      return Colors.red.shade700;
    default:
      return const Color.fromRGBO(9, 9, 9, 100);
  }
}
