import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_was_it_app/view/intro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.brown,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown),
          textTheme: const TextTheme(
            bodyText2: TextStyle(fontFamily: 'GowunDodum'),
          )
        ),
        home: Intro(),
      ),
    );
  }
}
