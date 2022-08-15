import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/provider.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/home/add_note_screen.dart';
import 'package:what_was_it_app/view/component/icon_card_widget.dart';
import 'package:what_was_it_app/view/main/main_drawer.dart';
import 'package:what_was_it_app/view/my_notes/my_note_list_view.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context, ref) {
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
            onTap: () {},
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
