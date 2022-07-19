import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final String title;
  final String category;
  final List<String> keywords;
  final List<int> alarmPeriods;
  final bool isRepeatable;
  final DateTime pubDate;

  Note({
    required this.title,
    required this.category,
    required this.keywords,
    required this.alarmPeriods,
    required this.isRepeatable,
    required this.pubDate,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
