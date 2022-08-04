import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  RepeatType repeatType = RepeatType.daily;
  DateTime alarmStartsAt = DateTime.now();
  final ScrollListViewController _monthController = ScrollListViewController();
  final ScrollListViewController _dayController = ScrollListViewController();
  final AlarmListViewController _alarmController = AlarmListViewController();

  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _monthController.addListener(() {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          alarmStartsAt = DateTime.now().add(Duration(days: _monthController.getCurrentIndex() * 30 + _dayController.getCurrentIndex()));
        });
      });
    });
    _dayController.addListener(() {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          alarmStartsAt = DateTime.now().add(Duration(days: _monthController.getCurrentIndex() * 30 + _dayController.getCurrentIndex()));
        });
      });
    });
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _alarmController.dispose();
    _categoryController.dispose();

    super.dispose();
  }

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
                  child: Text('알람 주기를 입력해주세요'),
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
                if (!isAlarmTypeRepeatable)
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: InkWell(
                      onTap: () {
                        // 반복성 알람은 1회만 설정 가능
                        if (isAlarmTypeRepeatable && _alarmController.getAlarmList().length == 1) return;

                        DateTime alarm = getDateAfter(_monthController.getCurrentIndex(), _dayController.getCurrentIndex());
                        final now = DateTime.now();
                        if (alarm.difference(DateTime(now.year, now.month, now.day)).inDays == 0) return;

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
                if (isAlarmTypeRepeatable)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "'${alarmStartsAt.month}월 ${alarmStartsAt.day}일'부터  ",
                        style: kLargeTextStyle.copyWith(color: Theme.of(context).primaryColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<RepeatType>(
                          value: repeatType,
                          icon: Icon(FontAwesomeIcons.angleDown, color: Theme.of(context).primaryColor),
                          style: kLargeTextStyle.copyWith(color: Theme.of(context).primaryColor),
                          items: const [
                            DropdownMenuItem(value: RepeatType.daily, child: Text(' 매일 ')),
                            DropdownMenuItem(value: RepeatType.weekly, child: Text(' 매주 ')),
                            DropdownMenuItem(value: RepeatType.monthly, child: Text(' 매달 ')),
                            DropdownMenuItem(value: RepeatType.yearly, child: Text(' 매년 ')),
                          ],
                          onChanged: (val) {
                            if (val == null) return;
                            setState(() {
                              repeatType = val;
                            });
                          },
                        ),
                      ),
                      Text("반복", style: kLargeTextStyle.copyWith(color: Theme.of(context).primaryColor)),
                    ],
                  ),
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
          isFormEmpty() => (_categoryController.text.isEmpty || (!isAlarmTypeRepeatable && _alarmController.getAlarmList().isEmpty));

          if (isFormEmpty()) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('카테고리와 알람을 모두 입력해주세요.')));
            return;
          }

          final data = ref.read(AddNoteScreen.addNoteDataProvider);

          data['category'] = _categoryController.text;
          data['scheduleDates'] = (isAlarmTypeRepeatable)
              ? [
                  getDateAfter(_monthController.getCurrentIndex(), _dayController.getCurrentIndex()),
                ]
              : _alarmController.getAlarmList();
          data['repeatType'] = (isAlarmTypeRepeatable) ? repeatType : null;
          data['pubDate'] = DateTime.now();

          Navigator.pop(
            context,
            Note(
              title: data['title'],
              category: data['category'],
              keywords: data['keywords'],
              scheduleDates: data['scheduleDates'],
              repeatType: data['repeatType'],
              pubDate: data['pubDate'],
            ),
          );
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}

DateTime getDateAfter(int month, int day) {
  var date = DateTime.now();
  return DateTime(
    date.year,
    date.month + month,
    date.day + day,
  );
}
