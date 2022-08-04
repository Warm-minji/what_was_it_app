import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/note.dart';

class NoteDetailView extends StatelessWidget {
  NoteDetailView({Key? key, required this.note}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FontAwesomeIcons.noteSticky, color: Theme.of(context).primaryColor),
              const SizedBox(width: 10),
              Text(
                note.title,
                style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontFamily: 'GowunDodum',
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 3, height: 0),
        SizedBox(
          height: 50,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Row(
              children: [
                Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    '카테고리 : ${note.category}',
                    style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 3, height: 0),
        SizedBox(
          height: 50,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '시작 날짜 : ${formatDate(note.pubDate)}',
              style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Divider(thickness: 3, height: 0),
        SizedBox(
          height: 50,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '알람 종류 : ${(note.repeatType != null) ? '반복성 알람' : '일회성 알람'}',
              style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Divider(thickness: 3, height: 0),
        SizedBox(
          height: 50,
          child: (note.repeatType == null)
              ? Row(
                  children: [
                    Text(
                      '시작일로부터',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                    ),
                    Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        scrollDirection: Axis.horizontal,
                        itemCount: note.scheduleDates.length,
                        itemBuilder: (context, idx) {
                          DateTime schedule = note.scheduleDates[idx];

                          int day = schedule.difference(DateTime(note.pubDate.year, note.pubDate.month, note.pubDate.day)).inDays;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor),
                              ),
                              child: Text(
                                // '${(month != 0) ? '$month개월 ' : ''}'
                                '$day일 후',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Align(
                  child: Text(
                    getDescOfPeriodicAlarm(note),
                    style: kLargeTextStyle.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
        ),
        const Divider(thickness: 3, height: 0),
        const SizedBox(height: 50),
        const Divider(thickness: 3, height: 0),
        SizedBox(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FontAwesomeIcons.bars, color: Theme.of(context).primaryColor),
              const SizedBox(width: 10),
              Text(
                '관련 키워드 목록',
                style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontFamily: 'GowunDodum',
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 3, height: 0),
        Expanded(
          child: ListView.builder(
            itemCount: note.keywords.length + 1,
            itemBuilder: (context, idx) {
              return Column(
                children: [
                  (idx < note.keywords.length)
                      ? SizedBox(
                          height: 50,
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                              child: Text(
                                note.keywords[idx],
                                style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(height: 50),
                  const Divider(height: 0, thickness: 3),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  String getDescOfPeriodicAlarm(Note note) {
    if (note.repeatType == null) return "";

    switch (note.repeatType!) {
      case RepeatType.daily:
        return "매일 반복";
      case RepeatType.weekly:
        return "매주 ${weekDayToString(note.scheduleDates[0].weekday)}요일마다 반복";
      case RepeatType.monthly:
        return "매달 ${note.scheduleDates[0].day}일마다 반복";
      case RepeatType.yearly:
        return "매년 ${note.scheduleDates[0].month}월 ${note.scheduleDates[0].day}일마다 반복";
    }
  }

  String weekDayToString(int weekDay) {
    switch (weekDay) {
      case 0:
        return "일";
      case 1:
        return "월";
      case 2:
        return "화";
      case 3:
        return "수";
      case 4:
        return "목";
      case 5:
        return "금";
      case 6:
        return "토";
    }
    throw Exception('weekDay must >= 0 and <= 6');
  }
}
