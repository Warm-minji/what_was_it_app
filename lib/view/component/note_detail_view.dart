import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/date_functions.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/component/keywords_widget.dart';

final isNoteEditableProvider = StateProvider.autoDispose((ref) => false);

class NoteDetailView extends ConsumerStatefulWidget {
  NoteDetailView({Key? key, required this.note}) : super(key: key);

  Note note;

  @override
  ConsumerState<NoteDetailView> createState() => _NoteDetailViewState();
}

class _NoteDetailViewState extends ConsumerState<NoteDetailView> {
  final TextEditingController keywordController = TextEditingController();
  final KeywordWidgetController keywordWidgetController = KeywordWidgetController();

  @override
  void initState() {
    super.initState();
    widget.note.keywords.forEach(keywordWidgetController.addKeyword);
    keywordWidgetController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isNoteEditable = ref.watch(isNoteEditableProvider);

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
                  widget.note.title,
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
                          widget.note.category,
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
              '시작 날짜 : ${formatDate(widget.note.pubDate)}',
              style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Divider(thickness: 3, height: 0),
        Column(
          children: [
            SizedBox(
              height: 50,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  '알람 종류 : ${(widget.note.repeatType != RepeatType.none) ? '반복성 알람' : '일회성 알람'} [${widget.note.scheduledDates.first.hour}시 ${widget.note.scheduledDates.first.minute.toString().padLeft(2, "0")}분]',
                  style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Divider(thickness: 3, height: 0),
            if (widget.note.repeatType == RepeatType.none)
              SizedBox(
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
                        itemCount: widget.note.scheduledDates.length,
                        itemBuilder: (context, idx) {
                          int offset = getOffset(widget.note.scheduledDates[idx], widget.note.pubDate);

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
              )
            else
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Align(
                      child: Text(
                        getDescOfPeriodicAlarm(widget.note).split("\n")[0],
                        style: kLargeTextStyle.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  const Divider(thickness: 3, height: 0),
                  SizedBox(
                    height: 50,
                    child: Align(
                      child: Text(
                        getDescOfPeriodicAlarm(widget.note).split("\n")[1],
                        style: kLargeTextStyle.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
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
        if (isNoteEditable)
          SizedBox(
            height: 50,
            child: TextField(
              controller: keywordController,
              style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
              decoration: const InputDecoration(labelText: '', hintText: '추가할 키워드 입력 후 엔터!', prefixIcon: Icon(Icons.arrow_forward), contentPadding: EdgeInsets.zero),
              onSubmitted: (val) {
                val = val.trim();
                if (val.isEmpty) return;
                keywordWidgetController.addKeyword(val);
                keywordController.clear();
              },
            ),
          ),
        Expanded(child: KeywordsWidget(controller: keywordWidgetController, isEditable: isNoteEditable)),
      ],
    );
  }
}
