import 'package:flutter/material.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/component/no_title_frame_view.dart';

class MyNoteListView extends StatelessWidget {
  const MyNoteListView({Key? key, required this.noteList}) : super(key: key);

  final List<Note> noteList;

  @override
  Widget build(BuildContext context) {
    return NoTitleFrameView(
      body: Container(),
    );
  }
}
