import 'package:flutter/material.dart';

class NoTitleFrameView extends StatelessWidget {
  NoTitleFrameView({Key? key, required this.body, this.floatingActionButton}) : super(key: key);

  Widget body;
  FloatingActionButton? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
