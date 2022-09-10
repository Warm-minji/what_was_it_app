import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notification_permissions/notification_permissions.dart';
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

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _notificationPerm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshPermission();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _refreshPermission();
    }
  }

  Future _refreshPermission() async {
    final perm = await NotificationPermissions.getNotificationPermissionStatus();
    if (mounted) {
      setState(() {
        _notificationPerm = _checkNotificationPermission(perm);
      });
    }
    if (_checkNotificationPermission(perm)) {
      if (await ref.read(noteRepoProvider).shouldRefreshNotifications()) {
        await ref.read(noteRepoProvider).refreshNotifications();
      }
    }
  }

  bool _checkNotificationPermission(PermissionStatus perm) => !(perm == PermissionStatus.denied || perm == PermissionStatus.unknown);

  _showCupertinoStylePermRequest() async {
    await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('권한 요청'),
        content: const Text('알림 기능 사용을 위해\n알림 권한히 필요합니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await NotificationPermissions.requestNotificationPermissions();
            },
            child: const Text('권한 설정하기'),
          ),
        ],
      ),
    );
  }

  _showAndroidStylePermRequest() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('권한 요청'),
        content: const Text('알림 기능 사용을 위해\n알림 권한히 필요합니다.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await NotificationPermissions.requestNotificationPermissions();
            },
            child: const Text('권한 설정하기'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const appBarLeadingIconConstraints = BoxConstraints(minWidth: kToolbarHeight, minHeight: kToolbarHeight);

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
              await _refreshPermission();
              if (_notificationPerm) {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const UpcomingAlarmListView();
                    });
              } else {
                if (Platform.isIOS) {
                  await _showCupertinoStylePermRequest();
                } else {
                  await _showAndroidStylePermRequest();
                }
              }
            },
            child: ConstrainedBox(
              constraints: appBarLeadingIconConstraints,
              child: (_notificationPerm) ? const Icon(FontAwesomeIcons.bell) : const Icon(FontAwesomeIcons.bellSlash),
            ),
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

              ref.read(noteRepoProvider).saveNote(note);
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
