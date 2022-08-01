import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_was_it_app/repo/NoteRepo.dart';

final noteRepoProvider = Provider((ref) => NoteRepo());