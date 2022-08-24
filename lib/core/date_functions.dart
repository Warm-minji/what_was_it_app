import 'package:what_was_it_app/model/note.dart';

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

String getDescOfPeriodicAlarm(Note note) {
  switch (note.repeatType) {
    case RepeatType.none:
      return "";
    case RepeatType.daily:
      return "${formatDate(note.scheduledDates[0])}부터\n매일 반복\n[${note.scheduledDates.first.hour}시 ${note.scheduledDates.first.minute.toString().padLeft(2, "0")}분]";
    case RepeatType.weekly:
      return "${formatDate(note.scheduledDates[0])}부터\n매주 ${weekDayToString(note.scheduledDates[0].weekday)}요일마다 반복\n[${note.scheduledDates.first.hour}시 ${note.scheduledDates.first.minute.toString().padLeft(2, "0")}분]";
    case RepeatType.monthly:
      return "${formatDate(note.scheduledDates[0])}부터\n매달 ${note.scheduledDates[0].day}일마다 반복\n[${note.scheduledDates.first.hour}시 ${note.scheduledDates.first.minute.toString().padLeft(2, "0")}분]";
    case RepeatType.yearly:
      return "${formatDate(note.scheduledDates[0])}부터\n매년 ${note.scheduledDates[0].month}월 ${note.scheduledDates[0].day}일마다 반복\n[${note.scheduledDates.first.hour}시 ${note.scheduledDates.first.minute.toString().padLeft(2, "0")}분]";
  }
}
