import 'package:flutter/material.dart';

class AlarmListViewController extends ChangeNotifier {
  final List<Duration> _alarmList = [];

  AlarmListViewController();

  List<Duration> getAlarmList() => _alarmList;

  void addAlarm(Duration alarm) {
    if (_alarmList.contains(alarm)) {
      return;
    }
    _alarmList.add(alarm);
    _alarmList.sort();
    notifyListeners();
  }

  void removeAlarm(Duration alarm) {
    _alarmList.remove(alarm);
    notifyListeners();
  }
}