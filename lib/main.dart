import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:noteapp_localstorage_notification/constatnts/constant.dart';
import 'package:noteapp_localstorage_notification/controller/notifictaion.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'views/home.dart';

void main() async {
  runApp(const MyApp());
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  _initializeTimeZone();
  print(notes);
}

_initializeTimeZone() async {
  tz.initializeTimeZones();
  String timezone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timezone));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationMethod.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotePage(),
    );
  }
}
