import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/provider.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:what_was_it_app/view/home/add_note_screen.dart';
import 'package:what_was_it_app/view/component/icon_card_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                // TODO
              },
              child: const Icon(FontAwesomeIcons.bars),
            ),
            InkWell(
              onTap: () {
                // TODO
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

              ref.read(noteRepoProvider).saveNote(note);
            },
            child: IconCardWidget(icon: Icons.add_circle_outline, title: '기억 노트 추가하기'),
          ),
          InkWell(
            onTap: () {},
            child: IconCardWidget(icon: Icons.notes, title: '내 기억 노트 확인하기'),
          ),
        ],
      ),
    );
  }
}
