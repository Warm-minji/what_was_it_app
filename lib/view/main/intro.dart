import 'package:flutter/material.dart';
import 'package:what_was_it_app/view/home/home_screen.dart';

class Intro extends StatefulWidget {
  Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.addListener(() {
      setState(() {});
      if (_animationController.isCompleted) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) moveNextPage(context);
        });
      }
    });
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void moveNextPage(context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => moveNextPage(context),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(child: Opacity(opacity: _opacityAnimation.value, child: Image.asset("images/what_was_it_main.png"))),
              if (_opacityAnimation.value == 0.0)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 200),
                        const Text(
                          '기억하다',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('©2022. WarmMinji. All rights reserved.'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
