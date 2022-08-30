import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/provider.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/component/no_title_frame_view.dart';
import 'package:what_was_it_app/view/component/note_detail_view.dart';

class MyNoteListView extends ConsumerWidget {
  MyNoteListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    List<Note> noteList = ref.watch(noteRepoProvider);

    return NoTitleFrameView(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '내 기억 노트 목록',
                  style: TextStyle(fontSize: 22, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.none, fontFamily: 'GowunDodum'),
                ),
                const SizedBox(width: 10),
                Icon(FontAwesomeIcons.listOl, color: Theme.of(context).primaryColor),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: ListView.builder(
            itemCount: noteList.length,
            itemBuilder: (context, idx) {
              Note note = noteList[idx];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoTitleFrameView(
                          body: NoteDetailView(note: note),
                          floatingActionButton: FloatingActionButton(
                            child: const Icon(FontAwesomeIcons.trash),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('잠시만요'),
                                  content: const Text('정말 삭제하시겠어요?\n되돌릴 수 없습니다!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        ref.read(noteRepoProvider.notifier).removeNote(idx);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('네', style: TextStyle(color: Colors.red)),
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
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
