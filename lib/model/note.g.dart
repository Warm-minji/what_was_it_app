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
      scheduleDates: (json['scheduleDates'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      repeatType: $enumDecode(_$RepeatTypeEnumMap, json['repeatType']),
      pubDate: DateTime.parse(json['pubDate'] as String),
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'title': instance.title,
      'category': instance.category,
      'keywords': instance.keywords,
      'scheduleDates':
          instance.scheduleDates.map((e) => e.toIso8601String()).toList(),
      'repeatType': _$RepeatTypeEnumMap[instance.repeatType]!,
      'pubDate': instance.pubDate.toIso8601String(),
    };

const _$RepeatTypeEnumMap = {
  RepeatType.none: 'none',
  RepeatType.daily: 'daily',
  RepeatType.weekly: 'weekly',
  RepeatType.monthly: 'monthly',
  RepeatType.yearly: 'yearly',
};
