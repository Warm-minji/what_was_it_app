import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/component/keywords_widget.dart';
import 'package:what_was_it_app/view/home/add_note_alarm_screen.dart';

final noteProvider = StateProvider(
  (ref) => Note(
    title: "",
    category: "",
    keywords: [],
    alarmPeriods: [],
    isRepeatable: false,
    pubDate: DateTime.now(),
  ),
);

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  static final addNoteDataProvider = Provider<Map<String, dynamic>>((ref) => {});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteWidgetState();
}

class _AddNoteWidgetState extends ConsumerState<AddNoteScreen> with SingleTickerProviderStateMixin {
  late TextEditingController titleController;
  late TextEditingController keywordController;

  late KeywordWidgetController keywordWidgetController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    keywordController = TextEditingController();

    keywordWidgetController = KeywordWidgetController();
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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
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
                        decoration: const InputDecoration(
                          labelText: '',
                          hintText: '기억할 주제 입력!',
                          prefixIcon: Icon(Icons.arrow_forward),
                        ),
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
                        decoration: const InputDecoration(
                          labelText: '',
                          hintText: '키워드 입력 후 엔터!',
                          prefixIcon: Icon(Icons.arrow_forward),
                        ),
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (titleController.text.trim().isEmpty || keywordWidgetController.getKeywords().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('주제와 키워드를 모두 입력해주세요')));
            return;
          }
          ref.read(AddNoteScreen.addNoteDataProvider)['title'] = titleController.text;
          ref.read(AddNoteScreen.addNoteDataProvider)['keywords'] = keywordWidgetController.getKeywords();
          Navigator.pop(
            context,
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddNoteAlarmScreen()),
            ),
          );
        },
        child: const Icon(FontAwesomeIcons.angleRight),
      ),
    );
  }
}
