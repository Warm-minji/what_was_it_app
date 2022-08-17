import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/notification_plugin.dart';
import 'package:what_was_it_app/core/shared_preferences.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/view/main/main_drawer_item.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool isServerLive = false;

  @override
  void initState() {
    super.initState();
    _checkServer();
  }

  Future _checkServer() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        isServerLive = false;
      });
    }
  }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: InkWell(
                        onTap: () {
                          // TODO
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
                    const SizedBox(height: 20),
                    const Divider(thickness: 1, height: 0),
                    MainDrawerItem(
                      onTap: () {
                        // TODO
                      },
                      child: const Text("도움말"),
                    ),
                    const Divider(thickness: 1, height: 0),
                    MainDrawerItem(
                      onTap: () {
                        // TODO
                      },
                      child: const Text("통계 보기"),
                    ),
                    const Divider(thickness: 1, height: 0),
                    MainDrawerItem(
                      onTap: () {
                        // TODO
                      },
                      child: Text(
                        "기억 백업하기",
                        style: (isServerLive) ? null : const TextStyle(decoration: TextDecoration.lineThrough),
                      ),
                    ),
                    const Divider(thickness: 1, height: 0),
                    MainDrawerItem(
                      onTap: () {
                        // TODO
                      },
                      child: Text(
                        "기억 복구하기",
                        style: (isServerLive) ? null : const TextStyle(decoration: TextDecoration.lineThrough),
                      ),
                    ),
                    const Divider(thickness: 1, height: 0),
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
}
