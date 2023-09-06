import 'dart:convert';
import 'package:collection/collection.dart';

class NoteModel {
  final int id;
  final String title;
  final String content;
  final DateTime dateCreated;
  DateTime? notificationDate;
  // final bool hasNotification;
  final NotificationType notificationType;
  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.dateCreated,
    this.notificationDate,
    // required this.hasNotification,
    required this.notificationType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateCreated': dateCreated.toIso8601String(),
      'notificationDate': notificationDate?.toIso8601String(),
      // 'hasNotification': hasNotification,
      'notificationType': notificationType.string
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
        id: map['id'] as int,
        title: map['title'] as String,
        content: map['content'] as String,
        dateCreated: DateTime.parse(map['dateCreated']),
        notificationDate: DateTime.parse(map['notificationDate']),
        // hasNotification: map['hasNotification'] ?? false,
        notificationType: NotificationType.parse(map['notificationType']));
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source));
}

enum NotificationType {
  off('off'),
  onceoff('once off'),
  daily('daily'),
  weekly('weekly'),
  monthly('monthly');

  final String string;

  const NotificationType(this.string);

  static NotificationType parse(String str) {
    final type = values.firstWhereOrNull((element) => element.string == str);

    if (type == null) {
      throw FormatException('invalid message type', str);
    }
    return type;
  }
}
