import 'package:intl/intl.dart';

class DateTimeUtils {
  static bool isNight({
    int? date,
    int? sunrise,
    int? sunset,
  }) {
    bool isNight = false;
    if (date != null && sunrise != null && sunset != null) {
      DateTime dateTime = date.fromTimeStampToDateTime();
      DateTime sunriseTime = sunrise.fromTimeStampToDateTime();
      DateTime sunsetTime = sunset.fromTimeStampToDateTime();

      isNight = dateTime.isBefore(sunriseTime) || dateTime.isAfter(sunsetTime);
      return isNight;
    }
    return isNight;
  }

  static String getDayOrDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime startRange = now.subtract(const Duration(days: 7));
    DateTime endRange = now.add(const Duration(days: 7));
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime tomorrow = now.add(const Duration(days: 1));

    if (date.isAfter(startRange) && date.isBefore(endRange)) {
      // if (date.isSameDate(yesterday)) {
      //   return "Yesterday";
      // } else
      if (date.isSameDate(now)) {
        return "Today";
      }
      //  else if (date.isSameDate(tomorrow)) {
      //   return "Tomorrow";
      // }
      else {
        return DateFormat('EEEE, MMM dd').format(date);
        // return DateFormat('EEEE').format(date);
      }
    } else {
      return DateFormat('EEEE, MMM dd').format(date);
    }
  }
}

extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension TimeStampToDateTime on int {
  DateTime fromTimeStampToDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000);
  }
}
