import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/theme.dart';
import 'package:what_was_it_app/view/home/add_note_screen.dart';

class KeywordsWidget extends ConsumerWidget {
  const KeywordsWidget({Key? key, required this.keywords}) : super(key: key);

  final List<String> keywords;

  @override
  Widget build(BuildContext context, ref) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
          itemCount: keywords.length,
          itemBuilder: (context, idx) {
            return Column(
              children: [
                const Divider(height: 0, thickness: 2),
                Align(
                  alignment: (idx % 2 == 0) ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
                  child: GestureDetector(
                    onTap: () {
                      keywords.remove(keywords[idx]);
                      ref.read(keywordsProvider.state).state = [...keywords];
                    },
                    child: KeywordCard(keyword: keywords[idx]),
                  ),
                ),
                if (idx == keywords.length - 1) const Divider(height: 0, thickness: 2),
              ],
            );
          }),
    );
  }
}

class KeywordCard extends StatelessWidget {
  const KeywordCard({Key? key, required this.keyword}) : super(key: key);

  final String keyword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(keyword, style: kLargeTextStyle)),
          const SizedBox(width: 10),
          const Icon(FontAwesomeIcons.x),
        ],
      ),
    );
  }
}
