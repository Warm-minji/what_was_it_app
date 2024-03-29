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
import 'package:what_was_it_app/view/home/add_note_screen.dart';

class NoteListView extends ConsumerWidget {
  NoteListView({Key? key, this.noteList, this.alarmNoteList}) : super(key: key);

  final List<Note>? noteList;
  final List<AlarmNote>? alarmNoteList;

  @override
  Widget build(BuildContext context, ref) {
    bool showAlarmDate = false;

    if (alarmNoteList != null && noteList == null) {
      showAlarmDate = true;
    }

    List<Note> selectedNotes = (showAlarmDate) ? alarmNoteList!.map((e) => e.note).toList() : noteList ?? [];
    selectedNotes.sort((a, b) => b.pubDate.compareTo(a.pubDate));

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

        return Dismissible(
          key: GlobalKey(),
          background: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.grey,
              child: const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Icon(FontAwesomeIcons.pencil, color: Colors.white),
              ),
            ),
          ),
          secondaryBackground: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              child: const Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(FontAwesomeIcons.trash, color: Colors.white),
              ),
            ),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              final newNote = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNoteScreen(note: note)));
              if (newNote == null) return false;
              if (note.noteId != null) {
                await ref.read(noteProvider.notifier).modifyNote(note.noteId!, newNote);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("수정되었습니다.")));
              }
            } else if (direction == DismissDirection.endToStart) {
              return await showDialog(
                // TODO route로 변경하고 아래 동일 메소드 합치기
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('잠시만요'),
                  content: const Text('정말 삭제하시겠어요?\n되돌릴 수 없습니다!'),
                  actions: [
                    Consumer(
                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        return TextButton(
                          onPressed: () async {
                            await ref.read(noteProvider.notifier).removeNote(note);
                            Navigator.pop(context, true);
                          },
                          child: const Text('네', style: TextStyle(color: Colors.red)),
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('아니요'),
                    ),
                  ],
                ),
              );
            }
          },
          child: Padding(
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
                                            ref.read(noteProvider.notifier).removeNote(note);
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
                          Consumer(
                            builder: (BuildContext context, WidgetRef ref, Widget? child) {
                              return FloatingActionButton(
                                onPressed: () async {
                                  final newNote = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNoteScreen(note: note)));
                                  if (newNote == null) return;
                                  Navigator.pop(context); // TODO
                                  if (note.noteId != null) {
                                    await ref.read(noteProvider.notifier).modifyNote(note.noteId!, newNote);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("수정되었습니다.")));
                                  }
                                },
                                child: const Icon(FontAwesomeIcons.pencil),
                              );
                            },
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
                    if (showAlarmDate)
                      Text(
                        (note.repeatType != RepeatType.none) ? getDescOfPeriodicAlarm(note) : dateString,
                        textAlign: TextAlign.right,
                      ),
                    if (!showAlarmDate) Text("${formatDate(note.pubDate)} 등록"),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
