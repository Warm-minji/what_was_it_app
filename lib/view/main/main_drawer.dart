import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/notification_plugin.dart';
import 'package:what_was_it_app/core/shared_preferences.dart';
import 'package:what_was_it_app/core/theme.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: InkWell(
                        onTap: () {
                          showSettings(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(FontAwesomeIcons.gear, color: Theme.of(context).primaryColor),
                              const SizedBox(width: 10),
                              Text("설정", style: TextStyle(color: Theme.of(context).primaryColor)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: SizedBox(
                height: 60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    const SizedBox(height: 10),
                    const Text('©2022. WarmMinji. All rights reserved.', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showSettings(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        Time userAlarmTime = getUserAlarmTime();

        final TextEditingController hourController = TextEditingController();
        final TextEditingController minController = TextEditingController();

        hourController.text = "${userAlarmTime.hour}";
        minController.text = "${userAlarmTime.minute}".padLeft(2, "0");

        return SimpleDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: InkWell(
                onTap: () {
                  userAlarmTime = getUserAlarmTime();
                  hourController.text = "${userAlarmTime.hour}";
                  minController.text = "${userAlarmTime.minute}".padLeft(2, "0");
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
                          controller: hourController,
                          textAlign: TextAlign.center,
                          onChanged: (val) {
                            val = val.trim();
                            if (val.isNotEmpty) {
                              int? newHour = int.tryParse(val);
                              if (newHour == null || (newHour < 0 || newHour >= 24)) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("시간은 0~23까지의 숫자만 입력할 수 있습니다.")));
                                setState(() {
                                  hourController.text = userAlarmTime.hour.toString();
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
                          controller: minController,
                          textAlign: TextAlign.center,
                          onChanged: (val) {
                            val = val.trim();
                            if (val.isNotEmpty) {
                              int? newMinute = int.tryParse(val);
                              if (newMinute == null || (newMinute < 0 || newMinute >= 60)) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("분은 0~59까지의 숫자만 입력할 수 있습니다.")));
                                setState(() {
                                  hourController.text = userAlarmTime.minute.toString();
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
                  Text("${userAlarmTime.hour}시 ${userAlarmTime.minute.toString().padLeft(2, "0")}분에 알림이 전송됩니다."),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      },
    );

    Future _setUserAlarmTime(Time alarmTime) async {
      await prefs.setStringList("alarmTime", [
        ...[alarmTime.hour, alarmTime.minute, alarmTime.second].map((e) => e.toString()),
      ]);
    }
  }
}
