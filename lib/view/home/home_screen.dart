import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/notification_plugin.dart';
import 'package:what_was_it_app/core/provider.dart';
import 'package:what_was_it_app/core/shared_preferences.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/home/add_note_screen.dart';
import 'package:what_was_it_app/view/component/icon_card_widget.dart';
import 'package:what_was_it_app/view/main/main_drawer.dart';
import 'package:what_was_it_app/view/my_notes/my_note_list_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late Time userAlarmTime;
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    userAlarmTime = getUserAlarmTime();
    _hourController.text = "${userAlarmTime.hour}";
    _minController.text = "${userAlarmTime.minute}".padLeft(2, "0");
  }

  Future _setUserAlarmTime(Time alarmTime) async {
    await prefs.setStringList("alarmTime", [
      ...[alarmTime.hour, alarmTime.minute, alarmTime.second].map((e) => e.toString()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          child: const Icon(FontAwesomeIcons.bars),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            InkWell(
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => SimpleDialog(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: InkWell(
                          onTap: () {
                            init();
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(FontAwesomeIcons.xmark),
                          ),
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, setState) => Column(
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
                                    controller: _hourController,
                                    textAlign: TextAlign.center,
                                    onChanged: (val) {
                                      val = val.trim();
                                      if (val.isNotEmpty) {
                                        int? newHour = int.tryParse(val);
                                        if (newHour == null || (newHour < 0 || newHour >= 24)) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("시간은 0~23까지의 숫자만 입력할 수 있습니다.")));
                                          setState(() {
                                            _hourController.text = userAlarmTime.hour.toString();
                                          });
                                          FocusScope.of(context).unfocus();
                                          return;
                                        }

                                        setState(() {
                                          userAlarmTime = Time(newHour, userAlarmTime.minute);
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const Text(":", style: kLargeTextStyle),
                                Expanded(
                                  child: TextField(
                                    controller: _minController,
                                    textAlign: TextAlign.center,
                                    onChanged: (val) {
                                      val = val.trim();
                                      if (val.isNotEmpty) {
                                        int? newMinute = int.tryParse(val);
                                        if (newMinute == null || (newMinute < 0 || newMinute >= 60)) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("분은 0~59까지의 숫자만 입력할 수 있습니다.")));
                                          setState(() {
                                            _hourController.text = userAlarmTime.minute.toString();
                                          });
                                          FocusScope.of(context).unfocus();
                                          return;
                                        }

                                        setState(() {
                                          userAlarmTime = Time(userAlarmTime.hour, newMinute);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text("${userAlarmTime.hour}시 ${userAlarmTime.minute.toString().padLeft(2, "0")}분에 알람이 울립니다."),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text("잠시만요"),
                                          content: const Text("되돌릴 수 없습니다. 정말 삭제할까요?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                await flutterLocalNotificationsPlugin.cancelAll();
                                                await prefs.clear();
                                                if (mounted) Phoenix.rebirth(context);
                                              },
                                              child: const Text("삭제", style: TextStyle(color: Colors.red)),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("취소"),
                                            ),
                                          ],
                                        ));
                              },
                              child: const Text("모든 데이터 삭제하기", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(FontAwesomeIcons.bell),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: IconCardWidget(icon: FontAwesomeIcons.handshake, title: '반갑습니다', subtitle: '잊으셔도 괜찮아요. 같이 기억해요.', textColor: Colors.white),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () async {
              Note? note = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNoteScreen()));
              if (note == null) return;

              ref.read(noteRepoProvider.notifier).saveNote(note);
            },
            child: IconCardWidget(icon: Icons.add_circle_outline, title: '기억 노트 추가하기'),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyNoteListView(),
                ),
              );
            },
            child: IconCardWidget(icon: Icons.notes, title: '내 기억 노트 확인하기'),
          ),
        ],
      ),
      drawer: const MainDrawer(),
    );
  }
}
