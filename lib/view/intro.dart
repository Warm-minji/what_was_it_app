import 'package:flutter/material.dart';
import 'package:what_was_it_app/view/home/home_screen.dart';

class Intro extends StatelessWidget {
  const Intro({Key? key}) : super(key: key);

  void moveNextPage(context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => moveNextPage(context),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '당신이\n'),
                      TextSpan(text: '기억하고 싶은 것', style: TextStyle(color: Theme.of(context).primaryColor)),
                      TextSpan(text: '은\n무엇인가요?'),
                    ],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ),
                SizedBox(height: 200),
                Text(
                  '망각의 동물',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
