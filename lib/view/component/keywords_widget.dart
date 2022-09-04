import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:what_was_it_app/core/theme.dart';

class KeywordsWidget extends StatefulWidget {
  const KeywordsWidget({Key? key, this.controller, this.keywords}) : super(key: key);

  final KeywordWidgetController? controller;
  final List<String>? keywords;

  @override
  State<KeywordsWidget> createState() => _KeywordsWidgetState();
}

class _KeywordsWidgetState extends State<KeywordsWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> keywords = widget.controller?.getKeywords() ?? [];
    keywords.addAll(widget.keywords ?? []);

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
                              if (widget.controller != null) Row(
                                children: [
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      widget.controller!.removeKeyword(idx);
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
