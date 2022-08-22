import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/date_functions.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/note.dart';

class NoteDetailView extends StatelessWidget {
  const NoteDetailView({Key? key, required this.note}) : super(key: key);

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
              Expanded(
                child: Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontFamily: 'GowunDodum',
                  ),
                  overflow: TextOverflow.ellipsis,
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
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '카테고리 : ',
                        style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: Text(
                          note.category,
                          style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
              '알람 종류 : ${(note.repeatType != RepeatType.none) ? '반복성 알람' : '일회성 알람'}',
              style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Divider(thickness: 3, height: 0),
        if (note.repeatType == RepeatType.none) SizedBox(
                height: 50,
                child: Row(
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
                        itemCount: note.scheduledDates.length,
                        itemBuilder: (context, idx) {
                          int offset = getOffset(note.scheduledDates[idx], note.pubDate);

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor),
                              ),
                              child: Text(
                                // '${(month != 0) ? '$month개월 ' : ''}'
                                '$offset일 후',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ) else Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Align(
                      child: Text(
                        getDescOfPeriodicAlarm(note).split("\n")[0],
                        style: kLargeTextStyle.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  const Divider(thickness: 3, height: 0),
                  SizedBox(
                    height: 50,
                    child: Align(
                      child: Text(
                        getDescOfPeriodicAlarm(note).split("\n")[1],
                        style: kLargeTextStyle.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
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
}
