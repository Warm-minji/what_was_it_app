import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_was_it_app/core/shared_preferences.dart';
import 'package:what_was_it_app/model/note.dart';

class NoteRepo extends StateNotifier<List<Note>> {

  NoteRepo(List<Note> list) : super(list);

  void saveNote(Note note) {
    state = [note, ...state];

    prefs.setString('notes', jsonEncode(state));
  }

  void removeNote(int index) {
    state.removeAt(index);
    state = [...state];

    prefs.setString('notes', jsonEncode(state));
  }
}