import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/component/alarm_list_view.dart';
import 'package:what_was_it_app/view/component/no_title_frame_view.dart';
import 'package:what_was_it_app/view/component/scroll_list_view.dart';
import 'package:what_was_it_app/view/home/add_note_screen.dart';

class AddNoteAlarmScreen extends ConsumerStatefulWidget {
  const AddNoteAlarmScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddNoteAlarmScreen> createState() => _AddNoteAlarmScreenState();
}

class _AddNoteAlarmScreenState extends ConsumerState<AddNoteAlarmScreen> {
  bool isAlarmTypeRepeatable = false;
  final ScrollListViewController _monthController = ScrollListViewController();
  final ScrollListViewController _dayController = ScrollListViewController();
  final AlarmListViewController _alarmController = AlarmListViewController();

  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return NoTitleFrameView(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                  tag: 'addNoteAlarm',
                  child: Text(
                    '알람 및 카테고리 추가',
                    style: TextStyle(fontSize: 22, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.none, fontFamily: 'GowunDodum'),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('카테고리를 입력해주세요.'),
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _categoryController,
                    style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
                    decoration: const InputDecoration(
                      labelText: '',
                      hintText: '카테고리 입력!',
                      prefixIcon: Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('알람 타입을 선택해주세요.'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!isAlarmTypeRepeatable) {
                              isAlarmTypeRepeatable = true;
                              _alarmController.clear();
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isAlarmTypeRepeatable ? Theme.of(context).primaryColor : Colors.transparent,
                            border: Border.all(color: Theme.of(context).primaryColor),
                          ),
                          child: Center(
                            child: Text(
                              '반복성 알람',
                              style: kLargeTextStyle.copyWith(
                                fontWeight: FontWeight.normal,
                                color: isAlarmTypeRepeatable ? Colors.white : Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isAlarmTypeRepeatable) {
                              isAlarmTypeRepeatable = false;
                              _alarmController.clear();
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: !isAlarmTypeRepeatable ? Theme.of(context).primaryColor : Colors.transparent,
                            border: Border.all(color: Theme.of(context).primaryColor),
                          ),
                          child: Center(
                            child: Text(
                              '일회성 알람',
                              style: kLargeTextStyle.copyWith(
                                fontWeight: FontWeight.normal,
                                color: !isAlarmTypeRepeatable ? Colors.white : Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 2),
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('알람 주기를 입력해주세요.\n[주의] 반복성 알람은 한 주기만 설정할 수 있습니다.'),
                ),
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: ScrollListView(
                          controller: _monthController,
                          item: [
                            ...[for (int i = 0; i <= 12; i++) i].map((e) => '$e개월')
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ScrollListView(
                          controller: _dayController,
                          item: [
                            ...[for (int i = 0; i <= 30; i++) i].map((e) => '$e일')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: InkWell(
                    onTap: () {
                      // 반복성 알람은 1회만 설정 가능
                      if (isAlarmTypeRepeatable && _alarmController.getAlarmList().length == 1) return;

                      // 30*개월 + 일
                      int alarm = _monthController.getCurrentIndex() * 30 + _dayController.getCurrentIndex();
                      if (alarm == 0) return;

                      _alarmController.addAlarm(alarm);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('알람 추가하기', style: TextStyle(color: Theme.of(context).primaryColor)),
                          Icon(Icons.arrow_right_alt, color: Theme.of(context).primaryColor),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(thickness: 2),
                const SizedBox(height: 10),
                AlarmListView(controller: _alarmController),
                const SizedBox(height: 10),
                const Divider(thickness: 2),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isFormEmpty() => (_categoryController.text.isEmpty || _alarmController.getAlarmList().isEmpty);

          if (isFormEmpty()) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('카테고리와 알람을 모두 입력해주세요.')));
            return;
          }

          final data = ref.read(AddNoteScreen.addNoteDataProvider);
          data['category'] = _categoryController.text;
          data['alarmPeriods'] = _alarmController.getAlarmList();
          data['isRepeatable'] = isAlarmTypeRepeatable;
          data['pubDate'] = DateTime.now();

          Navigator.pop(
            context,
            Note(
              title: data['title'],
              category: data['category'],
              keywords: data['keywords'],
              alarmPeriods: data['alarmPeriods'],
              isRepeatable: data['isRepeatable'],
              pubDate: data['pubDate'],
            ),
          );
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
