import 'package:flutter/material.dart';

import 'model.dart';

class NoteDetailPage extends StatefulWidget {
  final Note? note;
  final Function(NotificationOption)? onNotificationOptionChanged;
  final Function()? onAddNote;

  const NoteDetailPage({
    Key? key,
    this.note,
    this.onNotificationOptionChanged,
    this.onAddNote,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  bool isEditing = false;
  NotificationOption selectedOption = NotificationOption.off;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      isEditing = true;
      selectedOption = widget.note!.notificationOption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
              ),
            ),
            if (isEditing)
              DropdownButton<NotificationOption>(
                value: selectedOption,
                onChanged: (option) {
                  setState(() {
                    selectedOption = option!;
                  });
                  widget.onNotificationOptionChanged?.call(option!);
                },
                items: NotificationOption.values.map((option) {
                  return DropdownMenuItem<NotificationOption>(
                    value: option,
                    child: Text(optionToString(option)),
                  );
                }).toList(),
              ),
            ElevatedButton(
              onPressed: () {
                if (isEditing) {
                  widget.onAddNote?.call();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'Save Note' : 'Add Note'),
            ),
            if (isEditing)
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Note?'),
                        content: const Text(
                            'Are you sure you want to delete this note?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.onAddNote?.call();
                              Navigator.pop(context);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('Delete Note'),
              ),
          ],
        ),
      ),
    );
  }

  // void setNotificationOption(NotificationOption option) async {
  //   if (selectedNoteIndex >= 0 && selectedNoteIndex < notes.length) {
  //     final note = notes[selectedNoteIndex];
  //     DateTime? selectedDate;
  //     TimeOfDay? selectedTime;

  //     if (option != NotificationOption.off) {
  //       // Show date picker dialog
  //       final currentDate = DateTime.now();
  //       final initialDate = note.notificationTime ?? currentDate;
  //       final date = await showDatePicker(
  //         context: context,
  //         initialDate: initialDate,
  //         firstDate: currentDate,
  //         lastDate: DateTime(currentDate.year + 5),
  //       );

  //       if (date != null) {
  //         selectedDate = date;

  //         // Show time picker dialog
  //         final currentTime = TimeOfDay.now();
  //         final initialTime = note.notificationTime != null
  //             ? TimeOfDay.fromDateTime(note.notificationTime!)
  //             : currentTime;
  //         final time = await showTimePicker(
  //           context: context,
  //           initialTime: initialTime,
  //         );

  //         if (time != null) {
  //           selectedTime = time;
  //         }
  //       }
  //     }

  //     final newNote = Note(
  //       id: note.id,
  //       title: note.title,
  //       content: note.content,
  //       createdDate: note.createdDate,
  //       lastModifiedDate: note.lastModifiedDate,
  //       isPinned: note.isPinned,
  //       notificationDate: selectedDate != null && selectedTime != null
  //           ? DateTime(
  //               selectedDate.year,
  //               selectedDate.month,
  //               selectedDate.day,
  //               selectedTime.hour,
  //               selectedTime.minute,
  //             )
  //           : null,
  //       notificationOption: option,
  //     );

  //     setState(() {
  //       notes[selectedNoteIndex] = newNote;
  //       saveNotes();
  //     });

  //     await cancelNotification(note.id);
  //     if (option != NotificationOption.off &&
  //         selectedDate != null &&
  //         selectedTime != null) {
  //       final title = 'Note Notification';
  //       final content = 'This is a reminder for your note: ${note.title}';
  //       await scheduleNotification(
  //         note.id,
  //         title,
  //         content,
  //         newNote.notificationDate!,
  //       );
  //     }
  //   }
  // }
}
