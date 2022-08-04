import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final String title;
  final String category;
  final List<String> keywords;
  final List<DateTime> scheduleDates;
  final RepeatType? repeatType; // no repeat iff this value is null
  final DateTime pubDate;

  Note({
    required this.title,
    required this.category,
    required this.keywords,
    required this.scheduleDates,
    required this.repeatType,
    required this.pubDate,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}

enum RepeatType {
  daily,
  weekly,
  monthly,
  yearly,
}
