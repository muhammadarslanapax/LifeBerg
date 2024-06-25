import 'package:intl/intl.dart';

class DateUtility {
  static bool isResetTimeReached(DateTime now, DateTime lastCheckedDate) {
    DateTime resetTimeToday = DateTime(now.year, now.month, now.day, 2, 0);

    bool isAfterResetToday =
        now.isAfter(resetTimeToday) || now.isAtSameMomentAs(resetTimeToday);

    bool isLastCheckedBeforeToday = lastCheckedDate.isBefore(resetTimeToday);

    return isAfterResetToday && isLastCheckedBeforeToday;
  }

  static String formatDateForJournal(String date) {
    // Parse the UTC date string to a DateTime object
    DateTime utcDateTime = DateTime.parse(date);

    // Convert the UTC DateTime to local DateTime
    DateTime localDateTime = utcDateTime.toLocal();

    // Define the desired date format
    DateFormat formatter = DateFormat('MMMM d, yyyy');

    // Format the local DateTime to the desired string format
    return formatter.format(localDateTime);
  }

  static DateTime? parseDate(String? dateStr) {
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }
}
