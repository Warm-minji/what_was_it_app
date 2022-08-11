int getOffsetFromToday(DateTime date) {
  var now = DateTime.now();
  now = DateTime(now.year, now.month, now.day); // remove hours, minutes....

  return date.difference(now).inDays;
}

int getOffset(DateTime date, DateTime other) {
  return DateTime(date.year, date.month, date.day).difference(DateTime(other.year, other.month, other.day)).inDays;
}

DateTime getDateAfter(int month, int day, DateTime other) {
  return DateTime(
    other.year,
    other.month + month,
    other.day + day,
  );
}

DateTime getDateAfterFromToday(int month, int day) {
  return getDateAfter(month, day, DateTime.now());
}

String formatDate(DateTime date) {
  return '${date.year}년 ${date.month}월 ${date.day}일';
}

String weekDayToString(int weekDay) {
  switch (weekDay) {
    case 0:
      return "일";
    case 1:
      return "월";
    case 2:
      return "화";
    case 3:
      return "수";
    case 4:
      return "목";
    case 5:
      return "금";
    case 6:
      return "토";
  }
  throw Exception('weekDay must >= 0 and <= 6');
}