import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:what_was_it_app/core/notification_plugin.dart';
import 'package:what_was_it_app/core/shared_preferences.dart';
import 'package:what_was_it_app/view/intro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  // TODO onboarding check

  // await prefs.clear(); // clear all
  await _initializeNotification();

  runApp(const MyApp());
}

Future _initializeNotification() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Asia/Seoul"));
  const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/what_was_it_icon');
  const IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosInitializationSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
        home: Intro(),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('ko', 'KR'),
        ],
      ),
    );
  }
}
