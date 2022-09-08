import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/theme.dart';

class KeywordsWidget extends StatelessWidget {
  const KeywordsWidget({Key? key, required this.controller, this.isEditable = true}) : super(key: key);

  final KeywordWidgetController controller;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    List<String> keywords = controller.getKeywords();

    return ListView.builder(
        itemCount: max(5, keywords.length),
        itemBuilder: (context, idx) {
          return Column(
            children: [
              (idx < keywords.length)
                  ? SizedBox(
                      height: 50,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  keywords[idx],
                                  style: kLargeTextStyle.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isEditable)
                                Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        controller.removeKeyword(idx);
                                      },
                                      child: Icon(FontAwesomeIcons.eraser, color: Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(height: 50),
              const Divider(height: 0, thickness: 3),
            ],
          );
        });
  }
}

class KeywordWidgetController extends ChangeNotifier {
  final List<String> _keywords = [];

  List<String> getKeywords() => _keywords;

  void addKeyword(String keyword) {
    _keywords.add(keyword);
    notifyListeners();
  }

  void removeKeyword(int index) {
    if (index < 0 || index >= _keywords.length) {
      return;
    }
    _keywords.removeAt(index);
    notifyListeners();
  }
}
