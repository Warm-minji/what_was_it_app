// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      title: json['title'] as String,
      category: json['category'] as String,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      alarmPeriods:
          (json['alarmPeriods'] as List<dynamic>).map((e) => e as int).toList(),
      isRepeatable: json['isRepeatable'] as bool,
      pubDate: DateTime.parse(json['pubDate'] as String),
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'title': instance.title,
      'category': instance.category,
      'keywords': instance.keywords,
      'alarmPeriods': instance.alarmPeriods,
      'isRepeatable': instance.isRepeatable,
      'pubDate': instance.pubDate.toIso8601String(),
    };
