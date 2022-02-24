import 'package:intl/intl.dart' as intl;

class Time {
  timeAgo(
    DateTime dateTime,
  ) {
    String time;
    final DateTime isNow = DateTime.now();

    if (isNow.difference(dateTime).inSeconds < 59) {
      time = "now";
    } else if (isNow.difference(dateTime).inSeconds > 59 &&
        isNow.difference(dateTime).inHours < 24) {
      time = "${intl.DateFormat.Hm().format(dateTime).toString()}";
    } else if (isNow.difference(dateTime).inHours > 24 &&
        isNow.difference(dateTime).inDays < 365) {
      time =
          "${intl.DateFormat.MMMd().format(dateTime).toString()} - ${intl.DateFormat.Hm().format(dateTime).toString()}";
    } else if (isNow.difference(dateTime).inDays > 365) {
      time = "${intl.DateFormat.yMMMMd().format(dateTime).toString()}";
    }
    return time;
  }
}
