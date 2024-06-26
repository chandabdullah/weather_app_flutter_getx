extension TimeStampToDateTime on int {
  DateTime fromTimeStampToDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000);
  }
}
