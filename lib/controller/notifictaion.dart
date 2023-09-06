// ignore_for_file: unreachable_switch_case, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noteapp_localstorage_notification/constatnts/constant.dart';
import 'package:noteapp_localstorage_notification/controller/storage_method.dart';
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

  static Future<void> setNotification(
      BuildContext context, NoteModel note, NotificationType type) async {
    var date = setNotificationOption(context: context, type: type);
    final newNote = NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        dateCreated: note.dateCreated,
        notificationType: type,
        notificationDate: selectedDate);

    var index = notes.indexWhere((element) => element.id == note.id);
    notes[index] = newNote;
    NoteStorage.saveNotes(notes);
    print(newNote);
    print(notes[index].notificationType);
    print(notes[index].notificationDate);

    await NotificationMethod.cancelNotification(note.id);

    final time = tz.TZDateTime.from(date as DateTime, tz.local);
    await flutterLocalNotificationPlugin.zonedSchedule(
        note.id,
        'Notification',
        "This is reminder for you",
        tz.TZDateTime(tz.local, time.year, time.month, time.day, time.hour),
        const NotificationDetails(
            android: AndroidNotificationDetails('test notifi', "todo ",
                importance: Importance.high, priority: Priority.max)),
        payload: "info",
        matchDateTimeComponents: dateTimeComponents(type, note.id),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exact);
  }

  static DateTimeComponents? dateTimeComponents(
      NotificationType notificationType, int noteId) {
    return switch (notificationType) {
      NotificationType.onceoff => DateTimeComponents.time,
      NotificationType.daily => DateTimeComponents.dateAndTime,
      NotificationType.weekly => DateTimeComponents.dayOfWeekAndTime,
      NotificationType.monthly => DateTimeComponents.dayOfMonthAndTime,
      _ => cancelNotification(noteId)
    };
  }

  static Future<DateTime> setNotificationOption({
    required BuildContext context,
    required NotificationType type,
    // required NoteModel note
  }) async {
    final stuff = await notificationDayAndTime(context);
    print("${stuff.notificationDate}, ${stuff.notificationTime}");
    if (type != NotificationType.off) {
      if (stuff.notificationDate != null) {
        theDate = stuff.notificationDate;
        if (stuff.notificationTime != null) {
          theTime = stuff.notificationTime;
          selectedDate = DateTime(
              theDate!.year, theDate!.month, theDate!.day, theTime!.hour);
          print(selectedDate);
        }
      }
    }
    return selectedDate;
  }

  static Future<({DateTime? notificationDate, TimeOfDay? notificationTime})>
      notificationDayAndTime(BuildContext context) async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2050));
    var time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    return (notificationDate: date, notificationTime: time);
  }

  static cancelNotification(int noteId) async {
    await flutterLocalNotificationPlugin.cancel(noteId);
  }
}
