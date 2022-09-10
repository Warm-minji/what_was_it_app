import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({Key? key, required this.title, required this.content, required this.positiveAction, required this.negativeAction, this.positiveText = "확인", this.negativeText = "취소"}) : super(key: key);

  final Widget title;
  final Widget content;
  final Function positiveAction;
  final Function negativeAction;
  final String positiveText;
  final String negativeText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(onPressed: () => positiveAction(), child: Text(positiveText)),
        TextButton(onPressed: () => negativeAction(), child: Text(negativeText)),
      ],
    );
  }
}
