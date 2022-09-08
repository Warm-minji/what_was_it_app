import 'package:json_annotation/json_annotation.dart';
import 'package:what_was_it_app/model/notification.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  String? noteId;
  final String title;
  final String category;
  final List<String> keywords;
  final List<DateTime> scheduledDates;
  final RepeatType repeatType; // no repeat iff this value is null
  final DateTime pubDate;
  List<Notification>? notifications;

  Note({
    required this.title,
    required this.category,
    required this.keywords,
    required this.scheduledDates,
    required this.repeatType,
    required this.pubDate,
    this.notifications,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}

enum RepeatType {
  none,
  daily,
  weekly,
  monthly,
  yearly,
}
