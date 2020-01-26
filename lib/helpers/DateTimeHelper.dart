class DateTimeHelper {
  /// Calicourse's API returns us date like 2020-01-24T22:05:51+00:00
  /// Dart core can't parse them, so let's do it here ourselves.
  static DateTime createDateTimeFromApiString(String dateAsString) {
    // Replace "+xx:xx" by a 'Z'
    // @https://api.flutter.dev/flutter/dart-core/DateTime/parse.html
    String dateFormatted = dateAsString.substring(0, dateAsString.length - 6) + 'Z';
    return DateTime.parse(dateFormatted);
  }
}