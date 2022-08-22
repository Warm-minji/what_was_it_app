import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:what_was_it_app/core/notification_plugin.dart';
import 'package:what_was_it_app/core/provider.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/home/add_note_screen.dart';
import 'package:what_was_it_app/view/component/icon_card_widget.dart';
import 'package:what_was_it_app/view/home/upcoming_alarm_list_view.dart';
import 'package:what_was_it_app/view/main/main_drawer.dart';
import 'package:what_was_it_app/view/my_notes/my_note_list_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    NotificationPermissions.getNotificationPermissionStatus().then((perm) {
      if (perm == PermissionStatus.denied || perm == PermissionStatus.unknown) {
        // print(perm);
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            if (Platform.isIOS) {
              await showCupertinoDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('권한 요청'),
                  content: const Text('원활한 사용을 위해\n알림 권한히 필요합니다.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('알겠습니다'),
                    ),
                  ],
                ),
              );
            } else {
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('권한 요청'),
                  content: const Text('앱을 사용하기 위해\n알림 권한히 필요합니다.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('네'),
                    ),
                  ],
                ),
              );
            }
            await NotificationPermissions.requestNotificationPermissions();
            if (mounted) Phoenix.rebirth(context);
          }
        });
      }
    });
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
        actions: [
          InkWell(
            onTap: () async {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return UpcomingAlarmListView();
                  });
            },
            child: ConstrainedBox(constraints: const BoxConstraints(minWidth: kToolbarHeight, minHeight: kToolbarHeight), child: const Icon(FontAwesomeIcons.bell)),
          ),
        ],
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
