import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/component/alarm_list_view.dart';
import 'package:what_was_it_app/view/component/no_title_frame_view.dart';
import 'package:what_was_it_app/view/home/add_note_screen.dart';

class AddNoteAlarmScreen extends ConsumerStatefulWidget {
  const AddNoteAlarmScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddNoteAlarmScreen> createState() => _AddNoteAlarmScreenState();
}

class _AddNoteAlarmScreenState extends ConsumerState<AddNoteAlarmScreen> {
  bool isAlarmTypeRepeatable = false;
  RepeatType repeatType = RepeatType.none;
  DateTime alarmStartsAt = DateTime.now();

  final AlarmListViewController _alarmController = AlarmListViewController();
  final TextEditingController _categoryController = TextEditingController();

  final now = DateTime.now();

  @override
  void dispose() {
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
                              repeatType = RepeatType.daily;
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
                              repeatType = RepeatType.none;
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
                  child: Text('알람 주기를 선택해주세요.'),
                ),
                SfDateRangePicker(
                  selectionMode: (isAlarmTypeRepeatable) ? DateRangePickerSelectionMode.single : DateRangePickerSelectionMode.multiple,
                  enablePastDates: false,
                  showNavigationArrow: true,
                  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                    if (isAlarmTypeRepeatable) {
                      DateTime selected = args.value as DateTime;
                      setState(() {
                        alarmStartsAt = selected;
                      });
                    } else {
                      List<DateTime> selected = args.value as List<DateTime>;
                      _alarmController.setAlarmList(selected);
                    }
                  },
                ),
                const Divider(thickness: 2),
                const SizedBox(height: 10),
                if (isAlarmTypeRepeatable)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          DateTime? selected = await showDatePicker(context: context, initialDate: now, firstDate: now, lastDate: DateTime(2200));
                          if (selected == null) return;
                          setState(() {
                            alarmStartsAt = selected;
                          });
                        },
                        child: Text(
                          "'${alarmStartsAt.month}월 ${alarmStartsAt.day}일'부터  ",
                          style: kLargeTextStyle.copyWith(color: Theme.of(context).primaryColor),
                        ),
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
                if (!isAlarmTypeRepeatable) AlarmListView(controller: _alarmController),
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
          data['scheduleDates'] = (isAlarmTypeRepeatable) ? [alarmStartsAt] : _alarmController.getAlarmList();
          data['repeatType'] = repeatType;
          data['pubDate'] = now;

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
