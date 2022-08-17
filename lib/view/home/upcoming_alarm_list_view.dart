import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/date_functions.dart';
import 'package:what_was_it_app/core/notification_plugin.dart';
import 'package:what_was_it_app/core/provider.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/alarm_note.dart';
import 'package:what_was_it_app/model/note.dart';

class UpcomingAlarmListView extends ConsumerStatefulWidget {
  const UpcomingAlarmListView({Key? key}) : super(key: key);

  @override
  ConsumerState<UpcomingAlarmListView> createState() => _UpcomingAlarmListViewState();
}

class _UpcomingAlarmListViewState extends ConsumerState<UpcomingAlarmListView> {
  late List<AlarmNote> noRepeatNotes;
  late List<AlarmNote> repeatNotes;
  late List<AlarmNote> selectedNotes;

  bool repeatSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("예정된 기억 알림 목록", style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal)),
                    SizedBox(width: 10),
                    Icon(FontAwesomeIcons.listUl),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            repeatSelected = true;
                            selectedNotes = repeatNotes;
                          });
                        },
                        child: Container(
                          color: (repeatSelected) ? Theme.of(context).primaryColor : null,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "반복성 알림",
                                style: TextStyle(
                                  color: (repeatSelected) ? Colors.white : null,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            repeatSelected = false;
                            selectedNotes = noRepeatNotes;
                          });
                        },
                        child: Container(
                          color: (!repeatSelected) ? Theme.of(context).primaryColor : null,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "일회성 알림",
                                style: TextStyle(
                                  color: (!repeatSelected) ? Colors.white : null,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 3, height: 0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder(
              future: flutterLocalNotificationsPlugin.pendingNotificationRequests(),
              builder: (BuildContext context, AsyncSnapshot<List<PendingNotificationRequest>> snapshot) {
                List<Note> noteList = ref.read(noteRepoProvider);
                List<AlarmNote> upcomingAlarmList = [];
                if (snapshot.data?.isEmpty ?? true) return Container();

                for (var item in snapshot.data!) {
                  for (var note in noteList) {
                    if (note.notificationId?.contains(item.id) ?? false) {
                      upcomingAlarmList.add(AlarmNote(note: note, scheduledDate: note.scheduledDates[note.notificationId!.indexOf(item.id)]));
                      break;
                    }
                  }
                }

                noRepeatNotes = upcomingAlarmList.where((note) => note.note.repeatType == RepeatType.none).toList();
                repeatNotes = upcomingAlarmList.where((note) => note.note.repeatType != RepeatType.none).toList();
                selectedNotes = (repeatSelected) ? repeatNotes : noRepeatNotes;
                selectedNotes.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

                return ListView.builder(
                  itemCount: selectedNotes.length,
                  itemBuilder: (context, idx) {
                    AlarmNote alarmNote = selectedNotes[idx];

                    String dateString;
                    if (alarmNote.scheduledDate.year == DateTime.now().year) {
                      dateString = "${alarmNote.scheduledDate.month}월 ${alarmNote.scheduledDate.day}일 ${alarmNote.scheduledDate.hour}시 ${alarmNote.scheduledDate.minute.toString().padLeft(2, "0")}분";
                    } else {
                      dateString = "${formatDate(alarmNote.scheduledDate)} ${alarmNote.scheduledDate.hour}시 ${alarmNote.scheduledDate.minute.toString().padLeft(2, "0")}분";
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(
                          alarmNote.note.title,
                          style: kLargeTextStyle.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        subtitle: Text('카테고리 : ${alarmNote.note.category}'),
                        shape: Border.all(color: Theme.of(context).primaryColor),
                        trailing: Text((repeatSelected) ? getDescOfPeriodicAlarm(alarmNote.note) : dateString),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
