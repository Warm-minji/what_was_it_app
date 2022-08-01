import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/component/no_title_frame_view.dart';
import 'package:what_was_it_app/view/component/note_detail_view.dart';

class MyNoteListView extends StatelessWidget {
  MyNoteListView({Key? key, required this.noteList}) : super(key: key);

  final List<Note> noteList;
  int showDetailIndex = -1;

  @override
  Widget build(BuildContext context) {
    return NoTitleFrameView(
      body: Column(
        children: [
          Row(
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
                        MaterialPageRoute(builder: (context) => NoTitleFrameView(body: NoteDetailView(note: note))),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        note.title,
                        style: kLargeTextStyle.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      subtitle: Text('카테고리 : ${note.category}'),
                      shape: Border.all(color: Theme.of(context).primaryColor),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
