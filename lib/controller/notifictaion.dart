// ignore_for_file: unreachable_switch_case

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noteapp_localstorage_notification/model/note_model.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationMethod {
  static DateTime? theDate;
  static TimeOfDay? theTime;
  static DateTime selectedDate = DateTime.now();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static initializeNotification() async {
    InitializationSettings settings = const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings(),
        linux: LinuxInitializationSettings(defaultActionName: 'alert'),
        macOS: DarwinInitializationSettings());
    await flutterLocalNotificationPlugin.initialize(settings);
  }

  static setNotification(int noteIndex, NotificationType type) async {
    final time = tz.TZDateTime.from(selectedDate, tz.local);
    await flutterLocalNotificationPlugin.zonedSchedule(
        noteIndex,
        'Notification',
        "This is reminder for you",
        tz.TZDateTime(tz.local, time.year, time.month, time.day, time.hour),
        const NotificationDetails(
            android: AndroidNotificationDetails('test notifi', "todo ",
                importance: Importance.high, priority: Priority.max)),
        payload: "info",
        matchDateTimeComponents: dateTimeComponent(type),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exact);
  }

  static DateTimeComponents component = DateTimeComponents.time;
  static DateTimeComponents dateTimeComponent(NotificationType type) {
    if (type != NotificationType.off) {
      switch (type) {
        case NotificationType.onceoff:
          component = DateTimeComponents.time;
          break;
        case NotificationType.daily:
          component = DateTimeComponents.dateAndTime;
          break;
        case NotificationType.weekly:
          component = DateTimeComponents.dayOfWeekAndTime;
          break;
        case NotificationType.weekly:
          component = DateTimeComponents.dayOfMonthAndTime;
          break;
        default:
          break;
      }
    }
    return component;
  }

  Future<void> cancelNotification(int noteId) async {
    await flutterLocalNotificationPlugin.cancel(noteId);
  }

  static setNotificationOption(
      {required BuildContext context,
      required NotificationType type,
      required NoteModel note}) async {
    if (type != NotificationType.off) {
      final date = await pickDate(context);
      if (date != null) {
        theDate = date;

        final time = await pickTime(context);
        if (time != null) {
          theTime = time;
          selectedDate = DateTime(
              theDate!.year, theDate!.month, theDate!.day, theTime!.hour);
          print(selectedDate);
        }
      }
    }
  }

  static Future<DateTime?> pickDate(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2050));
  }

  static Future<TimeOfDay?> pickTime(BuildContext context) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }
}
