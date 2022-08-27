import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:what_was_it_app/view/home/home_screen.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) moveNextPage(context);
      });
    });
  }

  void moveNextPage(context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => moveNextPage(context),
      child: Scaffold(
        body: SafeArea(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: '당신이\n'),
                        TextSpan(text: '기억하고 싶은 것', style: TextStyle(color: Theme.of(context).primaryColor)),
                        const TextSpan(text: '은\n무엇인가요?'),
                      ],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 2 / 1,
                        child: Image.asset(
                          "images/what_was_it_main.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('©2022. hi-jin-dev. All rights reserved.'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
