import 'package:flutter/material.dart';

class MainDrawerItem extends StatelessWidget {
  const MainDrawerItem({Key? key, required this.onTap, required this.child}) : super(key: key);

  final Function onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Row(
              children: [
                child,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
