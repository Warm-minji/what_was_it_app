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
import 'package:what_was_it_app/view/component/note_list_view.dart';

class UpcomingAlarmListView extends ConsumerStatefulWidget {
  const UpcomingAlarmListView({Key? key}) : super(key: key);

  @override
  ConsumerState<UpcomingAlarmListView> createState() => _UpcomingAlarmListViewState();
}

class _UpcomingAlarmListViewState extends ConsumerState<UpcomingAlarmListView> {
  List<AlarmNote> noRepeatNotes = [];
  List<AlarmNote> repeatNotes = [];
  List<AlarmNote> selectedNotes = [];

  bool repeatSelected = false;

  _changeSelection({required bool repeatNoteSelected}) {
    repeatSelected = repeatNoteSelected;
    if (repeatSelected) {
      selectedNotes = repeatNotes;
    } else {
      selectedNotes = noRepeatNotes;
    }
    setState(() {});
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
                    const SizedBox(width: 10),
                    const Icon(FontAwesomeIcons.listUl),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _changeSelection(repeatNoteSelected: true);
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
                          _changeSelection(repeatNoteSelected: false);
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
                if (snapshot.data?.isEmpty ?? true) return Container();

                List<Note> noteList = ref.watch(noteProvider).value ?? [];

                final upcomingAlarmList = _getUpcomingAlarmList(snapshot.data!, noteList);

                noRepeatNotes = upcomingAlarmList.where((note) => note.note.repeatType == RepeatType.none).toList();
                repeatNotes = upcomingAlarmList.where((note) => note.note.repeatType != RepeatType.none).toList();
                selectedNotes = (repeatSelected) ? repeatNotes : noRepeatNotes;
                selectedNotes.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

                return NoteListView(alarmNoteList: selectedNotes);
              },
            ),
          ),
        ),
      ],
    );
  }

  List<AlarmNote> _getUpcomingAlarmList(List<PendingNotificationRequest> pendingNotificationRequests, List<Note> noteList) {
    List<AlarmNote> result = [];

    for (final note in noteList) {
      final notifications = note.notifications;
      if (notifications == null) continue;

      for (final notification in notifications) {
        if (pendingNotificationRequests.map((e) => e.id).contains(notification.notificationId)) {
          result.add(AlarmNote(note: note, scheduledDate: notification.notificationDate));
        }
      }
    }

    return result;
  }
}
