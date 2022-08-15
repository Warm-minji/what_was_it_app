import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

Time getUserAlarmTime() {
  if (prefs.containsKey("alarmTime")) {
    List<String>? alarmTime = prefs.getStringList("alarmTime");
    if (alarmTime == null) throw Exception("prefs alarmTime must be List<String> type");
    if (alarmTime.length != 3) throw Exception("prefs alarmTime must be length 3");

    return Time(int.parse(alarmTime[0]), int.parse(alarmTime[1]), int.parse(alarmTime[2]));
  } else {
    prefs.setStringList("alarmTime", ["9", "0", "0"]);
    return const Time(9, 0, 0);
  }
}