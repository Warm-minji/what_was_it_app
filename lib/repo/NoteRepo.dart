import 'dart:convert';

import 'package:what_was_it_app/core/shared_preferences.dart';
import 'package:what_was_it_app/model/note.dart';

class NoteRepo {
  NoteRepo();

  void saveNote(Note note) {
    List<Note> current = getNoteList();
    current = [note, ...current];

    prefs.setString('notes', jsonEncode(current));
  }

  List<Note> getNoteList() {
    List<Note> result = [];

    if (prefs.containsKey('notes')) {
      String? notes = prefs.getString('notes');
      if (notes == null) throw Exception('The prefs key "notes" should be String type');

      for (Map<String, dynamic> noteData in jsonDecode(notes)) {
        result.add(Note.fromJson(noteData));
      }
    }

    return result;
  }
}