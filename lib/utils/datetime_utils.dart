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
}

extension TimeStampToDateTime on int {
  DateTime fromTimeStampToDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000);
  }
}
