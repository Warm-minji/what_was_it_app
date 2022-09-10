import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/provider.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/component/no_title_frame_view.dart';
import 'package:what_was_it_app/view/component/note_detail_view.dart';
import 'package:what_was_it_app/view/component/note_list_view.dart';

class MyNoteListView extends ConsumerStatefulWidget {
  MyNoteListView({Key? key}) : super(key: key);

  @override
  ConsumerState<MyNoteListView> createState() => _MyNoteListViewState();
}

class _MyNoteListViewState extends ConsumerState<MyNoteListView> {
  String filter = "";

  @override
  Widget build(BuildContext context) {
    List<Note> noteList = ref.watch(noteProvider);
    List<Note> filteredNoteList = noteList.where((element) => element.category.replaceAll(" ", "").contains(filter)).toList();

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
          TextField(
            decoration: InputDecoration(
              hintText: "카테고리로 검색",
              hintStyle: TextStyle(color: Theme.of(context).primaryColor)
            ),
            style: TextStyle(color: Theme.of(context).primaryColor),
            onChanged: (val) {
              setState(() {
                filter = val.replaceAll(" ", "");
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(child: NoteListView(noteList: filteredNoteList)),
        ],
      ),
    );
  }
}
