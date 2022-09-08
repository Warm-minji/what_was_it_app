import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/date_functions.dart';
import 'package:what_was_it_app/core/provider.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/alarm_note.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/component/no_title_frame_view.dart';
import 'package:what_was_it_app/view/component/note_detail_view.dart';

class NoteListView extends StatelessWidget {
  NoteListView({Key? key, this.noteList, this.alarmNoteList}) : super(key: key);

  final List<Note>? noteList;
  final List<AlarmNote>? alarmNoteList;

  @override
  Widget build(BuildContext context) {
    bool showAlarmDate = false;

    if (alarmNoteList != null && noteList == null) {
      showAlarmDate = true;
    }

    List<Note> selectedNotes = (showAlarmDate) ? alarmNoteList!.map((e) => e.note).toList() : noteList ?? [];

    return ListView.builder(
      itemCount: selectedNotes.length,
      itemBuilder: (context, idx) {
        Note note = selectedNotes[idx];

        String dateString = '';
        if (showAlarmDate) {
          assert(alarmNoteList != null);
          DateTime scheduledDate = alarmNoteList![idx].scheduledDate;
          if (scheduledDate.year == DateTime.now().year) {
            dateString = "${scheduledDate.month}월 ${scheduledDate.day}일 ${scheduledDate.hour}시 ${scheduledDate.minute.toString().padLeft(2, "0")}분";
          } else {
            dateString = "${formatDate(scheduledDate)} ${scheduledDate.hour}시 ${scheduledDate.minute.toString().padLeft(2, "0")}분";
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoTitleFrameView(
                    body: NoteDetailView(note: note),
                    floatingActionButton: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          heroTag: "delete",
                          backgroundColor: Colors.red,
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('잠시만요'),
                                content: const Text('정말 삭제하시겠어요?\n되돌릴 수 없습니다!'),
                                actions: [
                                  Consumer(
                                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                      return TextButton(
                                        onPressed: () {
                                          ref.read(noteRepoProvider).removeNote(note);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('네', style: TextStyle(color: Colors.red)),
                                      );
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('아니요'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Icon(FontAwesomeIcons.trash),
                        ),
                        const SizedBox(width: 10),
                        FloatingActionButton(
                          onPressed: () {  },
                          child: const Icon(FontAwesomeIcons.pencil),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          note.title,
                          style: kLargeTextStyle.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text('카테고리 : ${note.category}'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    (note.repeatType != RepeatType.none) ? getDescOfPeriodicAlarm(note) : dateString,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
