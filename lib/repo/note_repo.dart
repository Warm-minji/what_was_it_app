import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_was_it_app/core/notification_plugin.dart';
import 'package:what_was_it_app/core/shared_preferences.dart';
import 'package:what_was_it_app/model/note.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;
import 'package:what_was_it_app/model/notification.dart';

class NoteRepo extends StateNotifier<List<Note>> {
  static const String host = "disconnect server"; // 15.164.144.82:8080

  NoteRepo(List<Note> list) : super(list);

  Future saveNote(Note note) async {
    state = [note, ...state];
    await _registerNoteToNotificationSystem(note);
    await _saveNotesInLocal(state);
  }

  Future removeNote(int index) async {
    await _removeNotification(state.elementAt(index));
    state.removeAt(index);
    state = [...state];
    await _saveNotesInLocal(state);
  }

  Future<bool> checkServerConnection() async {
    final url = Uri.http(host, "/");
    final req = http.Request("GET", url);

    bool check = false;
    try {
      final res = await req.send().timeout(const Duration(seconds: 3), onTimeout: () {
        check = false;
        return http.StreamedResponse(Stream.value([]), 408);
      });

      // TODO 404로 체크하는 방법 말고 괜찮은 방법이 있을까..
      if (res.statusCode == 404) check = true;
    } on Exception catch(e) {
      return false;
    }

    return check;
  }

  Future loadFromRemote(String userId, String password) async {
    // throw Exception("err");
    final url = Uri.http(host, "/api/restore", {
      "memberId": userId,
      "password": password,
    });
    final req = http.Request("GET", url);

    final res = await req.send().timeout(const Duration(seconds: 3), onTimeout: () {
      throw Exception("request timeout");
    });
    if (res.statusCode != 200) {
      throw HttpException(jsonDecode(await res.stream.bytesToString())["errorMessage"]);
    }

    List<dynamic> mapNotes = jsonDecode(await res.stream.bytesToString());

    // print(mapNotes);
    List<Map<String, dynamic>> listNotes = [];
    for (Map<String, dynamic> mapNote in mapNotes) {
      mapNote["pubDate"] = mapNote["publishedDate"];
      switch (mapNote["repeatType"]) {
        case "NONE":
          mapNote["repeatType"] = "none";
          break;
        case "DAILY":
          mapNote["repeatType"] = "daily";
          break;
        case "WEEKLY":
          mapNote["repeatType"] = "weekly";
          break;
        case "MONTHLY":
          mapNote["repeatType"] = "monthly";
          break;
        case "YEARLY":
          mapNote["repeatType"] = "yearly";
          break;
      }
      listNotes.add(mapNote);
    }

    List<Note> result = [];
    for (Map<String, dynamic> mapNote in listNotes) {
      // print(mapNote);
      result.add(Note.fromJson(mapNote));
    }

    state = [];
    await prefs.clear();
    await flutterLocalNotificationsPlugin.cancelAll();
    for (Note note in result) {
      await saveNote(note);
    }
  }

  Future saveToRemote(String userId, String password, List<Note> notes) async {
    // throw Exception("err");
    final url = Uri.http(host, "/api/backup");
    final req = http.Request("POST", url);
    req.headers[HttpHeaders.contentTypeHeader] = "application/json";

    List<Map<String, dynamic>> listNotes = [];

    List<dynamic> mapNotes = jsonDecode(jsonEncode(notes));
    for (Map<String, dynamic> mapNote in mapNotes) {
      mapNote["memberId"] = userId;
      switch (mapNote["repeatType"]) {
        case "none":
          mapNote["repeatType"] = "NONE";
          break;
        case "daily":
          mapNote["repeatType"] = "DAILY";
          break;
        case "weekly":
          mapNote["repeatType"] = "WEEKLY";
          break;
        case "monthly":
          mapNote["repeatType"] = "MONTHLY";
          break;
        case "yearly":
          mapNote["repeatType"] = "YEARLY";
          break;
      }
      listNotes.add(mapNote);
    }

    req.body = jsonEncode({
      "memberId": userId,
      "password": password,
      "notes": listNotes,
    });

    final res = await req.send().timeout(const Duration(seconds: 3), onTimeout: () {
      throw Exception("request timeout");
    });
    if (res.statusCode != 200) {
      throw HttpException(jsonDecode(await res.stream.bytesToString())["errorMessage"]);
    }
  }

  Future _saveNotesInLocal(List<Note> notes) async {
    await prefs.setString("notes", jsonEncode(notes));
  }

  Future _removeNotification(Note note) async {
    if (note.notifications != null && note.notifications!.isNotEmpty) {
      // TODO map 관련 확인
      for (int notificationId in note.notifications!.map((e) => e.notificationId)) {
        await flutterLocalNotificationsPlugin.cancel(notificationId);
      }
      note.notifications = null;
    }
  }

  List<tz.TZDateTime> _getNoteAlarmDate(Note note) {
    List<tz.TZDateTime> result = [];

    for (DateTime alarmDate in note.scheduledDates) {
      final scheduledDate = tz.TZDateTime(tz.local, alarmDate.year, alarmDate.month, alarmDate.day, alarmDate.hour, alarmDate.minute);
      result.add(scheduledDate);
    }
    return result;
  }

  Future _registerNoteToNotificationSystem(Note note) async {
    int notificationId = _getNextNotificationId();

    for (tz.TZDateTime scheduledDate in _getNoteAlarmDate(note)) {
      // TODO map 동작 안하는데 왜 그런지 알아보기
      if (note.repeatType != RepeatType.none || scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
        await _addNotification(scheduledDate, note, notificationId++);
      } else {
        note.scheduledDates.remove(scheduledDate);
      }
    }

    await _setNextNotificationId(notificationId);
  }

  int _getNextNotificationId() {
    return prefs.getInt("notificationId") ?? 0;
  }

  Future<void> _setNextNotificationId(int id) async {
    await prefs.setInt("notificationId", id);
  }

  Future<void> _addNotification(tz.TZDateTime scheduledDate, Note note, int notificationId) async {
    _addNotificationInfoToNote(note, Notification(notificationId: notificationId, notificationDate: scheduledDate));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      "[기억하다] ${note.title} 기억 나시나요?",
      note.keywords.reduce((value, element) => "$value, $element"),
      scheduledDate,
      _getNotificationDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: _getDateTimeComponentOfNote(note),
    );

    // print("$scheduledDate에 알람이 설정됐습니다."); // Test
  }

  void _addNotificationInfoToNote(Note note, Notification notificationInfo) {
    note.notifications ??= [];
    note.notifications!.add(notificationInfo);
  }

  DateTimeComponents? _getDateTimeComponentOfNote(Note note) {
    DateTimeComponents? result;

    switch (note.repeatType) {
      case RepeatType.none:
        result = null;
        break;
      case RepeatType.daily:
        result = DateTimeComponents.time;
        break;
      case RepeatType.weekly:
        result = DateTimeComponents.dayOfWeekAndTime;
        break;
      case RepeatType.monthly:
        result = DateTimeComponents.dayOfMonthAndTime;
        break;
      case RepeatType.yearly:
        result = DateTimeComponents.dateAndTime;
        break;
    }

    return result;
  }

  NotificationDetails _getNotificationDetails() {
    IOSNotificationDetails iosNotificationDetails = const IOSNotificationDetails();
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      "whatWasIt",
      "what was it app",
      importance: Importance.max,
      priority: Priority.high,
    );
    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }
}
