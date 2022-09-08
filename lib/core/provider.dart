import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstore/localstore.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/repo/note_repo.dart';

final db = Localstore.instance;

final noteRepoProvider = Provider<NoteRepo>((ref) => NoteRepo(db));

final noteProvider = StreamProvider<List<Note>>((ref) => ref.read(noteRepoProvider).getNoteStream());