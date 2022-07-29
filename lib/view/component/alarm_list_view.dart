import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/view/component/alarm_list_view_controller.dart';

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
          ...widget.controller.getAlarmList().map((e) {
            int month = e.inDays ~/ 30;
            int day = e.inDays % 30;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
                child: Row(
                  children: [
                    Text('${(month != 0) ? '$month개월 ' : ''}$day일 후', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        widget.controller.removeAlarm(e);
                      },
                      child: Icon(FontAwesomeIcons.xmark, color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
