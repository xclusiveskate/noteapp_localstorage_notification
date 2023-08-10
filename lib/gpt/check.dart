// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:rxdart/rxdart.dart';
// import 'package:timezone/timezone.dart' as tz;

// import 'detail.dart';
// import 'home.dart';
// import 'model.dart';

// void main() {
//   runApp(NoteApp());
// }

// class NoteApp extends StatefulWidget {
//   @override
//   _NoteAppState createState() => _NoteAppState();
// }

// class _NoteAppState extends State<NoteApp> {
//   List<Note> notes = [];
//   final titleController = TextEditingController();
//   final contentController = TextEditingController();
//   int selectedNoteIndex = -1;
//   FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     initializeNotifications();
//     loadNotes();
//   }

//   Future<void> initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await notificationsPlugin.initialize(initializationSettings);
//   }

//   // Future<void> showNotification(String title, String content) async {
//   //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   //       AndroidNotificationDetails(
//   //     'note_app_channel',
//   //     'Note App Channel',
//   //     // 'Channel for Note App notifications',
//   //     importance: Importance.high,
//   //     priority: Priority.high,
//   //   );
//   //   const NotificationDetails platformChannelSpecifics =
//   //       NotificationDetails(android: androidPlatformChannelSpecifics);
//   //   await notificationsPlugin.show(
//   //     0,
//   //     title,
//   //     content,
//   //     platformChannelSpecifics,
//   //   );
//   // }

//   void setNotificationOption(NotificationOption option) async {
//     if (selectedNoteIndex >= 0 && selectedNoteIndex < notes.length) {
//       final note = notes[selectedNoteIndex];
//       final newNote = Note(
//         id: note.id,
//         title: note.title,
//         content: note.content,
//         createdDate: note.createdDate,
//         lastModifiedDate: note.lastModifiedDate,
//         isPinned: note.isPinned,
//         notificationDate: note.notificationDate,
//         notificationOption: option,
//       );
//       setState(() {
//         notes[selectedNoteIndex] = newNote;
//         saveNotes();
//       });

//       await cancelNotification(note.id);
//       if (option != NotificationOption.off) {
//         final now = DateTime.now();
//         DateTime? nextNotificationDate;
//         switch (option) {
//           case NotificationOption.daily:
//             nextNotificationDate = now.add(Duration(days: 1));
//             break;
//           case NotificationOption.weekly:
//             nextNotificationDate = now.add(Duration(days: 7));
//             break;
//           case NotificationOption.monthly:
//             nextNotificationDate = DateTime(now.year, now.month + 1, now.day);
//             break;
//           case NotificationOption.yearly:
//             nextNotificationDate = DateTime(now.year + 1, now.month, now.day);
//             break;
//           default:
//             break;
//         }
//         if (nextNotificationDate != null) {
//           final title = 'Note Notification';
//           final content = 'This is a reminder for your note: ${note.title}';
//           await scheduleNotification(
//               note.id, title, content, nextNotificationDate);
//         }
//       }
//     }
//   }

//   Future<void> scheduleNotification(
//       int id, String title, String content, DateTime scheduleDate) async {
//     final timeDifference = scheduleDate.difference(DateTime.now()).inSeconds;
//     if (timeDifference < 0) {
//       return; // Do not schedule notifications for past dates
//     }
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'note_app_channel',
//       'Note App Channel',
//       // 'Channel for Note App notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       content,
//       tz.TZDateTime.now(tz.local).add(Duration(seconds: timeDifference)),
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   Future<void> cancelNotification(int id) async {
//     await notificationsPlugin.cancel(id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Note App',
//       home: HomePage(
//         notes: notes,
//         onTapNote: (index) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => NoteDetailPage(
//                 note: notes[index],
//                 onNotificationOptionChanged: (option) =>
//                     setNotificationOption(option),
//               ),
//             ),
//           );
//         },
//         onAddNote: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => NoteDetailPage(
//                 onAddNote: addNote,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void loadNotes() async {
//     final prefs = await SharedPreferences.getInstance();
//     final encodedNotes = prefs.getStringList('notes');
//     if (encodedNotes != null) {
//       setState(() {
//         notes = encodedNotes
//             .map((encodedNote) =>
//                 Note.fromJson(jsonDecode(encodedNote) as Map<String, dynamic>))
//             .toList();
//       });
//     }
//   }

//   void saveNotes() async {
//     final prefs = await SharedPreferences.getInstance();
//     final encodedNotes =
//         notes.map((note) => jsonEncode(note.toJson())).toList();
//     await prefs.setStringList('notes', encodedNotes);
//   }

//   void addNote() {
//     final newNote = Note(
//       id: DateTime.now().millisecondsSinceEpoch,
//       title: titleController.text,
//       content: contentController.text,
//       createdDate: DateTime.now(),
//       lastModifiedDate: DateTime.now(),
//     );
//     setState(() {
//       notes.add(newNote);
//       saveNotes();
//       titleController.clear();
//       contentController.clear();
//     });
//   }

//   void updateNote() {
//     final updatedNote = Note(
//       id: notes[selectedNoteIndex].id,
//       title: titleController.text,
//       content: contentController.text,
//       createdDate: notes[selectedNoteIndex].createdDate,
//       lastModifiedDate: DateTime.now(),
//       isPinned: notes[selectedNoteIndex].isPinned,
//       notificationDate: notes[selectedNoteIndex].notificationDate,
//       notificationOption: notes[selectedNoteIndex].notificationOption,
//     );
//     setState(() {
//       notes[selectedNoteIndex] = updatedNote;
//       saveNotes();
//     });
//   }

//   void deleteNote() {
//     setState(() {
//       notes.removeAt(selectedNoteIndex);
//       saveNotes();
//     });
//     Navigator.pop(context);
//   }
// }
