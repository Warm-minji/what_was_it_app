import 'package:what_was_it_app/model/note.dart';

class AlarmNote {
  final Note note;
  final DateTime scheduledDate;

  const AlarmNote({required this.note, required this.scheduledDate});
}
