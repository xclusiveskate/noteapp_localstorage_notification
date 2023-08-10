// class Note {
//   int id;
//   String title;
//   String content;
//   DateTime createdDate;
//   DateTime lastModifiedDate;
//   bool isPinned;
//   DateTime? notificationDate;
//   NotificationOption notificationOption;

//   Note({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.createdDate,
//     required this.lastModifiedDate,
//     this.isPinned = false,
//     this.notificationDate,
//     this.notificationOption = NotificationOption.off,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'content': content,
//       'createdDate': createdDate.toIso8601String(),
//       'lastModifiedDate': lastModifiedDate.toIso8601String(),
//       'isPinned': isPinned,
//       'notificationDate': notificationDate?.toIso8601String(),
//       'notificationOption': notificationOption.index,
//     };
//   }

//   factory Note.fromJson(Map<String, dynamic> json) {
//     return Note(
//       id: json['id'],
//       title: json['title'],
//       content: json['content'],
//       createdDate: DateTime.parse(json['createdDate']),
//       lastModifiedDate: DateTime.parse(json['lastModifiedDate']),
//       isPinned: json['isPinned'],
//       notificationDate: json['notificationDate'] != null
//           ? DateTime.parse(json['notificationDate'])
//           : null,
//       notificationOption: NotificationOption.values[json['notificationOption']],
//     );
//   }
// }

// enum NotificationOption {
//   off,
//   daily,
//   weekly,
//   monthly,
//   yearly,
// }

// String optionToString(NotificationOption option) {
//   switch (option) {
//     case NotificationOption.off:
//       return 'Off';
//     case NotificationOption.daily:
//       return 'Daily';
//     case NotificationOption.weekly:
//       return 'Weekly';
//     case NotificationOption.monthly:
//       return 'Monthly';
//     case NotificationOption.yearly:
//       return 'Yearly';
//   }
// }
