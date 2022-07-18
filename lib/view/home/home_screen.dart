import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/view/home/add_note_widget.dart';
import 'package:what_was_it_app/view/component/icon_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
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
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: IconCardWidget(icon: FontAwesomeIcons.handshake, title: '반갑습니다', subtitle: '잊으셔도 괜찮아요. 같이 기억해요.', textColor: Colors.white),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                builder: (context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.7,
                    minChildSize: 0.7,
                    maxChildSize: 0.9,
                    expand: false,
                    builder: (context, scrollController) => SizedBox(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: AddNoteWidget(),
                      ),
                    ),
                  );
                },
              );
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
