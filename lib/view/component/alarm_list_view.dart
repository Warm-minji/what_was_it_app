import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:what_was_it_app/core/date_functions.dart';

class AlarmListView extends StatefulWidget {
  const AlarmListView({Key? key, required this.controller}) : super(key: key);

  final AlarmListViewController controller;

  @override
  State<AlarmListView> createState() => _AlarmListViewState();
}

class _AlarmListViewState extends State<AlarmListView> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.addListener(() {
        if (mounted) setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...widget.controller.getAlarmList().map(
            (e) {
              String date = "";
              if (e.year == DateTime.now().year) {
                date = "${e.month}월 ${e.day}일";
              } else {
                date = formatDate(e);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  child: Row(
                    children: [
                      Text(
                        // '${(month != 0) ? '$month개월 ' : ''}'
                        date,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                      ),
                      // const SizedBox(width: 10),
                      // InkWell(
                      //   onTap: () {
                      //     widget.controller.removeAlarm(e);
                      //   },
                      //   child: Icon(FontAwesomeIcons.xmark, color: Theme.of(context).primaryColor),
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AlarmListViewController extends ChangeNotifier {
  final List<DateTime> _alarmList = [];

  AlarmListViewController();

  List<DateTime> getAlarmList() => _alarmList;

  void setAlarmList(List<DateTime> list) {
    _alarmList.clear();
    _alarmList.addAll(list);
    _alarmList.sort();
    notifyListeners();
  }

  void addAlarm(DateTime alarm) {
    if (_alarmList.contains(alarm)) {
      return;
    }
    _alarmList.add(alarm);
    _alarmList.sort();
    notifyListeners();
  }

  void removeAlarm(DateTime alarm) {
    _alarmList.remove(alarm);
    notifyListeners();
  }

  void clear() {
    _alarmList.clear();
    notifyListeners();
  }
}
