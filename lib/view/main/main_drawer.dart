import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/notification_plugin.dart';
import 'package:what_was_it_app/core/provider.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/view/guide/guide_home.dart';
import 'package:what_was_it_app/view/main/main_drawer_item.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  bool isServerLive = false;

  @override
  void initState() {
    super.initState();
    _checkServerLive();
  }

  Future _checkServerLive() async {
    final check = await ref.read(noteRepoProvider.notifier).checkServerConnection();
    if (mounted) {
      setState(() {
        isServerLive = check;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const cancelLineTextStyle = TextStyle(decoration: TextDecoration.lineThrough);

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
                    // Align(
                    //   alignment: AlignmentDirectional.centerEnd,
                    //   child: InkWell(
                    //     onTap: () {
                    //       // TODO 설정 만들고 주석 해제
                    //     },
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(5.0),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Icon(FontAwesomeIcons.gear, color: Theme.of(context).primaryColor),
                    //           const SizedBox(width: 10),
                    //           Text("설정", style: TextStyle(color: Theme.of(context).primaryColor)),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1, height: 0),
                    MainDrawerItem(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const GuideHome()));
                      },
                      child: const Text("도움말"),
                    ),
                    const Divider(thickness: 1, height: 0),
                    MainDrawerItem(
                      onTap: () {
                        // TODO
                      },
                      child: const Text("통계 보기", style: cancelLineTextStyle),
                    ),
                    const Divider(thickness: 1, height: 0),
                    MainDrawerItem(
                      onTap: () async {
                        if (!isServerLive) return;

                        await showLoginDialog(context, saveMode: true);
                      },
                      child: Text(
                        "기억 백업하기",
                        style: (isServerLive) ? null : cancelLineTextStyle,
                      ),
                    ),
                    const Divider(thickness: 1, height: 0),
                    MainDrawerItem(
                      onTap: () async {
                        if (!isServerLive) return;

                        await showLoginDialog(context, saveMode: false);
                      },
                      child: Text(
                        "기억 복구하기",
                        style: (isServerLive) ? null : cancelLineTextStyle,
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
                                        await ref.read(noteRepoProvider).clearDB();
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
                    const Text('©2022. hi-jin-dev. All rights reserved.', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showLoginDialog(context, {saveMode}) async {
    String userId = "";
    String password = "";

    await showDialog(
        context: context,
        builder: (context) {
          String msg = "";
          const idMsg = "5~12 글자로 입력해주세요";
          const pwMsg = "6~20 글자로 입력해주세요";

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
                          children: [
                            const Icon(FontAwesomeIcons.floppyDisk),
                            const SizedBox(width: 10),
                            Text((saveMode) ? "기억 백업하기" : "기억 복구하기", style: kLargeTextStyle),
                          ],
                        ),
                        if (saveMode) Text("** 백업한 기억은 1회만 복구할 수 있습니다.", style: TextStyle(color: Theme.of(context).primaryColor)),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: "아이디",
                            counterText: idMsg,
                          ),
                          onChanged: (val) {
                            userId = val.trim();
                          },
                        ),
                        TextField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "비밀번호",
                            counterText: pwMsg,
                          ),
                          onChanged: (val) {
                            password = val.trim();
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(msg),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (userId.isEmpty || password.isEmpty) {
                                    setState(() {
                                      msg = "아이디 비밀번호를 모두 입력해주세요";
                                    });
                                    return;
                                  }
                                  if (userId.length < 5 || userId.length > 12) {
                                    setState(() {
                                      msg = "아이디는 $idMsg";
                                    });
                                    return;
                                  }
                                  if (password.length < 6 || password.length > 20) {
                                    setState(() {
                                      msg = "비밀번호는 $pwMsg";
                                    });
                                    return;
                                  }
                                  if (saveMode) {
                                    try {
                                      await ref.read(noteRepoProvider.notifier).saveToRemote(userId, password, ref.read(noteRepoProvider));
                                      if (mounted) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("백업 완료되었습니다.")));
                                      }
                                    } on HttpException catch(e) {
                                      setState(() {
                                        msg = e.message;
                                      });
                                    } catch(e) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("서버에 문제가 발생했습니다. 개발자에게 문의해주세요.")));
                                    }
                                  } else {
                                    try {
                                      await ref.read(noteRepoProvider.notifier).loadFromRemote(userId, password);
                                      if (mounted) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("복구 완료되었습니다.")));
                                      }
                                    } on HttpException catch(e) {
                                      setState(() {
                                        msg = e.message;
                                      });
                                    } catch(e) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("서버에 문제가 발생했습니다. 개발자에게 문의해주세요.")));
                                    }
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("확인", style: TextStyle(color: Colors.red)),
                                ),
                              ),
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text("취소", style: TextStyle(color: Theme.of(context).primaryColor)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        });
  }
}
