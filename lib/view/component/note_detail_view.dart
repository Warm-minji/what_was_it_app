
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
              '알람 종류 : ${(note.isRepeatable) ? '반복성 알람' : '일회성 알람'}',
              style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Divider(thickness: 3, height: 0),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
              const SizedBox(width: 10),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  scrollDirection: Axis.horizontal,
                  itemCount: note.alarmPeriods.length,
                  itemBuilder: (context, idx) {

                    int alarm = note.alarmPeriods[idx];

                    int month = alarm ~/ 30;
                    int day = alarm % 30;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor),
                        ),
                        child: Text(
                          '${(month != 0) ? '$month개월 ' : ''}${(day != 0) ? '$day일 ' : ''}후',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
}
