import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/view/component/keywords_widget.dart';
import 'package:what_was_it_app/view/home/add_note_alarm_screen.dart';

final keywordsProvider = StateProvider<List<String>>((ref) => []);

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  static final addNoteDataProvider = Provider<Map<String, dynamic>>((ref) => {});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteWidgetState();
}

class _AddNoteWidgetState extends ConsumerState<AddNoteScreen> with SingleTickerProviderStateMixin {
  late TextEditingController titleController;
  late TextEditingController keywordController;

  late AnimationController animationController;

  final List<String> keywords = [];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))..addListener(() => setState(() {}));

    titleController = TextEditingController();
    keywordController = TextEditingController();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 150), () => animationController.forward());
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    keywordController.dispose();
    animationController.dispose();
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
            child: Opacity(
              opacity: animationController.value,
              child: Stack(
                children: [
                  Column(
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
                      const SizedBox(height: 10),
                      TextField(
                        controller: titleController,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                          label: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text('기억할 주제를 입력해주세요', style: TextStyle(fontSize: 20)),
                          ),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: keywordController,
                        decoration: const InputDecoration(
                          label: Text('기억할 키워드를 입력해주세요', style: TextStyle(fontSize: 20)),
                          hintText: '한 단어 입력 후 엔터!',
                          hintStyle: TextStyle(fontSize: 13),
                        ),
                        onSubmitted: (val) {
                          val = val.trim();
                          if (val.isEmpty) return;
                          setState(() {
                            keywords.add(val);
                          });
                          keywordController.clear();
                        },
                      ),
                      const SizedBox(height: 20),
                      Expanded(child: KeywordsWidget(keywords: keywords)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (titleController.text.trim().isEmpty || keywords.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('주제와 키워드를 모두 입력해주세요')));
            return;
          }
          ref.read(AddNoteScreen.addNoteDataProvider)['title'] = titleController.text;
          ref.read(AddNoteScreen.addNoteDataProvider)['keywords'] = keywords;
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNoteAlarmScreen()));
        },
        child: const Icon(FontAwesomeIcons.angleRight),
      ),
    );
  }
}
