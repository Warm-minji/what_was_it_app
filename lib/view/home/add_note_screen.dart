import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/component/keywords_widget.dart';
import 'package:what_was_it_app/view/component/no_title_frame_view.dart';
import 'package:what_was_it_app/view/home/add_note_alarm_screen.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({Key? key, this.note}) : super(key: key);

  final Note? note;

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteWidgetState();
}

class _AddNoteWidgetState extends ConsumerState<AddNoteScreen> with SingleTickerProviderStateMixin {
  late TextEditingController titleController;
  late TextEditingController keywordController;

  late KeywordWidgetController keywordWidgetController;

  bool couldMoveToNext = false;

  final tempNote = Note(
    title: "",
    category: "",
    keywords: [],
    scheduledDates: [],
    repeatType: RepeatType.none,
    pubDate: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    keywordController = TextEditingController();

    keywordWidgetController = KeywordWidgetController();

    if (widget.note != null) {
      // modify mode
      final data = tempNote;
      data.noteId = widget.note!.noteId;
      data.title = widget.note!.title;
      data.category = widget.note!.category;
      data.keywords = widget.note!.keywords;
      data.scheduledDates = widget.note!.scheduledDates;
      data.repeatType = widget.note!.repeatType;
      data.pubDate = widget.note!.pubDate;
      data.notifications = widget.note!.notifications;

      titleController.text = data.title;
      data.keywords.forEach(keywordWidgetController.addKeyword);
      couldMoveToNext = true;
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      keywordWidgetController.addListener(() {
        if (mounted) {
          setState(() {
            couldMoveToNext = titleController.text.trim().isNotEmpty && (keywordWidgetController.getKeywords().isNotEmpty || keywordController.text.isNotEmpty);
          });
        }
      });
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    keywordController.dispose();
    keywordWidgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NoTitleFrameView(
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'addNoteAlarm',
                    child: Text(
                      '기억 메모장',
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontFamily: 'GowunDodum',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(FontAwesomeIcons.pencil, color: Theme.of(context).primaryColor),
                ],
              ),
            ),
          ),
          const Divider(thickness: 3, height: 0),
          SizedBox(
            height: 50,
            child: TextField(
              controller: titleController,
              style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
              decoration: const InputDecoration(labelText: '', hintText: '기억할 주제 입력!', prefixIcon: Icon(Icons.arrow_forward), contentPadding: EdgeInsets.zero),
              onChanged: (val) {
                setState(() {
                  couldMoveToNext = titleController.text.trim().isNotEmpty && (keywordWidgetController.getKeywords().isNotEmpty || keywordController.text.isNotEmpty);
                });
              },
            ),
          ),
          const SizedBox(height: 50),
          const Divider(thickness: 3, height: 0),
          SizedBox(
            height: 50,
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                '관련 키워드 목록',
                style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontFamily: 'GowunDodum',
                ),
              ),
            ),
          ),
          const Divider(thickness: 3, height: 0),
          SizedBox(
            height: 50,
            child: TextField(
              controller: keywordController,
              style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
              decoration: const InputDecoration(labelText: '', hintText: '키워드 입력 후 엔터!', prefixIcon: Icon(Icons.arrow_forward), contentPadding: EdgeInsets.zero),
              onChanged: (val) {
                setState(() {
                  couldMoveToNext = titleController.text.trim().isNotEmpty && (keywordWidgetController.getKeywords().isNotEmpty || keywordController.text.isNotEmpty);
                });
              },
              onSubmitted: (val) {
                val = val.trim();
                if (val.isEmpty) return;
                keywordWidgetController.addKeyword(val);
                keywordController.clear();
              },
            ),
          ),
          Expanded(child: KeywordsWidget(controller: keywordWidgetController)),
        ],
      ),
      floatingActionButton: (couldMoveToNext)
          ? FloatingActionButton(
              onPressed: () async {
                if (!couldMoveToNext) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('주제와 키워드를 모두 입력해주세요')));
                  return;
                }

                final val = keywordController.text;
                if (val.isNotEmpty) keywordWidgetController.addKeyword(val);

                tempNote.title = titleController.text;
                tempNote.keywords = keywordWidgetController.getKeywords();

                Navigator.pop(
                  context,
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNoteAlarmScreen(data: tempNote)),
                  ),
                );
              },
              child: const Icon(FontAwesomeIcons.angleRight),
            )
          : null,
    );
  }
}
