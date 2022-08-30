import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_was_it_app/core/shared_preferences.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/repo/note_repo.dart';

final noteRepoProvider = StateNotifierProvider<NoteRepo, List<Note>>((ref) {
  List<Note> result = [];

  if (prefs.containsKey('notes')) {
    String? notes = prefs.getString('notes');
    if (notes == null) throw Exception('The prefs key "notes" should be String type');

    for (Map<String, dynamic> noteData in jsonDecode(notes)) {
      result.add(Note.fromJson(noteData));
    }
  }

  return NoteRepo(result);
});