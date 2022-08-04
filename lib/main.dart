import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:what_was_it_app/core/shared_preferences.dart';
import 'package:what_was_it_app/view/intro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  // TODO onboarding check

  // await prefs.clear(); // clear all

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const primaryColor = Colors.brown;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: primaryColor,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor),
          textTheme: const TextTheme(
            bodyText2: TextStyle(fontFamily: 'GowunDodum'),
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: primaryColor,
          ),
        ),
        home: const Intro(),
      ),
    );
  }
}
