import 'package:flutter/material.dart';

class IconCardWidget extends StatelessWidget {
  IconCardWidget({
    Key? key,
    this.icon,
    required this.title,
    this.subtitle,
    this.textColor = Colors.black,
  }) : super(key: key);

  final IconData? icon;
  final String title;
  final String? subtitle;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 110,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                if (icon != null) Icon(icon, color: textColor),
                if (icon != null) const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ),
                      if (subtitle != null)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            subtitle!,
                            style: TextStyle(fontSize: 18, color: textColor),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 2, height: 0),
      ],
    );
  }
}
