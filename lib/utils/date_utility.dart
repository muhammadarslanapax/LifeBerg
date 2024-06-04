class DateUtility {

  static bool isResetTimeReached(DateTime now, DateTime lastCheckedDate) {
    DateTime resetTimeToday = DateTime(now.year, now.month, now.day, 2, 0);

    bool isAfterResetToday =
        now.isAfter(resetTimeToday) || now.isAtSameMomentAs(resetTimeToday);

    bool isLastCheckedBeforeToday = lastCheckedDate.isBefore(resetTimeToday);

    return isAfterResetToday && isLastCheckedBeforeToday;
  }


}