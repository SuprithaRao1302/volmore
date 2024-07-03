import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MiscService {
  static String getFormattedDate(Timestamp date) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000))
        .toString();
  }

  static String getTotalHours(dynamic log) {
    double hours = 0.0;
    DateTime startTime =
        log['startTime'].toDate(); // Convert Firestore Timestamp to DateTime
    DateTime endTime =
        log['endTime'].toDate(); // Convert Firestore Timestamp to DateTime

    Duration duration = endTime.difference(startTime);
    double totalHours = duration.inSeconds / 3600; // Convert duration to hours
    hours += totalHours;
    return hours.toString();
  }
}
