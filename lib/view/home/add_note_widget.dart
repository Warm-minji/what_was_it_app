import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AddNoteWidget extends StatefulWidget {
  const AddNoteWidget({Key? key}) : super(key: key);

  @override
  State<AddNoteWidget> createState() => _AddNoteWidgetState();
}

class _AddNoteWidgetState extends State<AddNoteWidget> with SingleTickerProviderStateMixin {
  late TextEditingController titleController;
  late TextEditingController keywordController;

  late AnimationController animationController;

  List<String> keywords = [];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))..addListener(() => setState(() {}));

    titleController = TextEditingController();
    keywordController = TextEditingController();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 250), () => animationController.forward());
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              Opacity(
                opacity: animationController.value,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
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
                      decoration: InputDecoration(
                        label: Text('기억할 키워드를 입력해주세요', style: TextStyle(fontSize: 20)),
                        hintText: '한 단어 입력 후 엔터!',
                        hintStyle: TextStyle(fontSize: 13),
                      ),
                      onSubmitted: (val) {
                        val = val.trim();
                        if (val.isEmpty) return;
                        keywords.add(val);
                        keywordController.clear();
                      },
                    ),
                    const SizedBox(height: 20),
                    // TODO keyword widget
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text('추가하기', style: TextStyle(fontSize: 24, color: Colors.white))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
