import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notification_permissions/notification_permissions.dart';
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
                    decoration: const InputDecoration(labelText: '', hintText: '카테고리 입력!', prefixIcon: Icon(Icons.arrow_forward), contentPadding: EdgeInsets.zero),
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
        onPressed: () async {
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

          final Time? alarmTime = await showSettings(context);
          if (alarmTime == null) return;

          List<DateTime> scheduleDates = data["scheduleDates"];
          List<DateTime> alarmTimeAppliedDates = [];
          for (DateTime date in scheduleDates) {
            alarmTimeAppliedDates.add(DateTime(date.year, date.month, date.day, alarmTime.hour, alarmTime.minute));
          }
          data["scheduleDates"] = alarmTimeAppliedDates;

          if (mounted) {
            Navigator.pop(
              context,
              Note(
                title: data['title'],
                category: data['category'],
                keywords: data['keywords'],
                scheduledDates: data['scheduleDates'],
                repeatType: data['repeatType'],
                pubDate: data['pubDate'],
              ),
            );
          }
        },
        child: const Icon(Icons.send),
      ),
    );
  }

  showSettings(context) async {
    Time alarmTime = const Time(9, 0);

    final TextEditingController hourController = TextEditingController();
    final TextEditingController minController = TextEditingController();

    hourController.text = "${alarmTime.hour}";
    minController.text = "${alarmTime.minute}".padLeft(2, "0");

    String msg = "";

    return await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(FontAwesomeIcons.clock),
                          SizedBox(width: 10),
                          Text("알림 시각 설정하기", style: kLargeTextStyle),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: hourController,
                              textAlign: TextAlign.center,
                              onChanged: (val) {
                                val = val.trim();
                                if (val.isNotEmpty) {
                                  if (val.length > 2) {
                                    msg = "두 숫자만 입력할 수 있습니다.";
                                    hourController.text = alarmTime.hour.toString();
                                    FocusScope.of(context).unfocus();
                                    return;
                                  }
                                  int? newHour = int.tryParse(val);
                                  if (newHour == null || (newHour < 0 || newHour >= 24)) {
                                    setState(() {
                                      msg = "시간은 0~23까지의 숫자만 입력할 수 있습니다.";
                                      hourController.text = alarmTime.hour.toString();
                                    });
                                    FocusScope.of(context).unfocus();
                                    return;
                                  }
                                  setState(() {
                                    msg = "";
                                    alarmTime = Time(newHour, alarmTime.minute);
                                  });
                                } else {
                                  setState(() {
                                    msg = "";
                                    alarmTime = Time(0, alarmTime.minute);
                                  });
                                }
                              },
                            ),
                          ),
                          const Text(":", style: kLargeTextStyle),
                          Expanded(
                            child: TextField(
                              controller: minController,
                              textAlign: TextAlign.center,
                              onChanged: (val) {
                                val = val.trim();
                                if (val.isNotEmpty) {
                                  if (val.length > 2) {
                                    msg = "두 숫자만 입력할 수 있습니다.";
                                    minController.text = alarmTime.minute.toString().padLeft(2, "0");
                                    FocusScope.of(context).unfocus();
                                    return;
                                  }
                                  int? newMinute = int.tryParse(val);
                                  if (newMinute == null || (newMinute < 0 || newMinute >= 60)) {
                                    setState(() {
                                      msg = "분은 0~59까지의 숫자만 입력할 수 있습니다.";
                                      minController.text = alarmTime.minute.toString().padLeft(2, "0");
                                    });
                                    FocusScope.of(context).unfocus();
                                    return;
                                  }
                                  setState(() {
                                    msg = "";
                                    alarmTime = Time(alarmTime.hour, newMinute);
                                  });
                                } else {
                                  setState(() {
                                    msg = "";
                                    alarmTime = Time(alarmTime.hour, 0);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text("${alarmTime.hour}시 ${alarmTime.minute.toString().padLeft(2, "0")}분에 알림이 전송됩니다."),
                      Text(msg, style: TextStyle(color: Theme.of(context).primaryColor)),
                      const SizedBox(height: 20),
                      FutureBuilder(
                        future: NotificationPermissions.getNotificationPermissionStatus(),
                        builder: (context, snapshot) {
                          final perm = snapshot.data;
                          if (perm == PermissionStatus.denied || perm == PermissionStatus.unknown) {
                            return const Text(
                              "현재 알림 기능이 비활성화 상태입니다.\n알림 기능을 이용하려면 홈화면 우측 상단을 클릭하여 설정 후 노트를 추가해주세요.\n\n추가 후에는 알림을 설정할 수 없습니다.",
                              style: TextStyle(color: Colors.red),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context, alarmTime);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("완료", style: TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
