import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstore/localstore.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/repo/note_repo.dart';

final db = Localstore.instance;

final noteRepoProvider = Provider<NoteRepo>((ref) => NoteRepo(db));

final noteProvider = StateNotifierProvider<NoteList, List<Note>>((ref) {
  return NoteList(db, ref.read(noteRepoProvider));
});

class NoteList extends StateNotifier<List<Note>> {
  final Localstore db;
  final NoteRepo repo;

  NoteList(this.db, this.repo) : super([]) {
    db.collection("notes").get().then((value) {
      if (value == null) {
        state = [];
      } else {
        final result = <Note>[];
        for (final noteId in value.keys) {
          result.add(Note.fromJson(value[noteId]));
        }
        state = result;
      }
    });
  }

  Future saveNote(Note note) async {
    await repo.saveNote(note);
    state = [note, ...state];
  }

  Future removeNote(Note note) async {
    await repo.removeNote(note);
    state.remove(note);
    state = [...state];
  }

  Future modifyNote(String noteId, Note newNote) async {
    await repo.modifyNote(noteId, newNote);
    state[state.indexWhere((element) => element.noteId == noteId)] = newNote;
    state = [...state];
  }
}
