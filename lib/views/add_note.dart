// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:noteapp_localstorage_notification/controller/notifictaion.dart';

import '../constatnts/constant.dart';
import '../controller/storage_method.dart';
import '../model/note_model.dart';
import '../utils/show_snackbar.dart';

class AddNote extends StatefulWidget {
  NoteModel? note;
  AddNote({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  ScrollController scrollControl = ScrollController();

  saveNote() async {
    bool status = await NoteStorage.saveNotes(notes);
    print(status);
  }

  addNote() async {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      var note = NoteModel(
          id: DateTime.now().millisecondsSinceEpoch,
          title: titleController.text,
          content: contentController.text,
          dateCreated: DateTime.now(),
          notificationDate: null,
          notificationType: selectedType);

      setState(() {
        notes.add(note);
        saveNote();
        titleController.clear();
        contentController.clear();
      });
      showSnackBar(context: context, message: 'note added successfully');

      Navigator.pop(context);
    } else {
      showSnackBar(context: context, message: "Field is empty");
    }
  }

  updateNote() async {}

  @override
  void initState() {
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      selectedType = widget.note!.notificationType;

      print(widget.note!.notificationType);
    }

    super.initState();
  }

  NotificationType selectedType = NotificationType.off;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 246, 235),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 246, 235),
        elevation: 0.5,
        actions: [
          IconButton(
              onPressed: widget.note != null ? updateNote : addNote,
              tooltip: widget.note != null ? "Edit Note" : "Save Note",
              icon: const Icon(
                Icons.done,
                size: 26,
                color: Color.fromARGB(255, 220, 166, 5),
                weight: 1,
              )),
          widget.note != null
              ? PopupMenuButton<NotificationType>(
                  tooltip: "Add notification",
                  position: PopupMenuPosition.over,
                  initialValue: selectedType,
                  onSelected: (value) async {
                    setState(() {
                      selectedType = value;
                    });
                    await NotificationMethod.setNotification(
                        context, widget.note!, selectedType);
                  },
                  onCanceled: () {},
                  icon: const Icon(Icons.notification_add),
                  itemBuilder: (context) {
                    return NotificationType.values
                        .map((type) => PopupMenuItem(
                              value: type,
                              child: Text(type.string),
                              onTap: () {
                                print(type);
                              },
                            ))
                        .toList();
                  })
              : const SizedBox.shrink()
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: scrollControl,
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                hintText: "Enter title",
              ),
            ),
            // DropdownButton(
            //     hint: const Text("Choose Category"),
            //     isExpanded: true,
            //     items: dropDownItems
            //         .map<DropdownMenuItem<String>>((e) =>
            //             DropdownMenuItem<String>(
            //                 value: e.toString(), child: Text(e.toString())))
            //         .toList(),
            //     value: selectedValue,
            //     onChanged: (String? value) {
            //       setState(() {
            //         selectedValue = value;
            //       });
            //     }),
            TextField(
              maxLines: null,
              minLines: null,
              // expands: true,
              controller: contentController,

              decoration: const InputDecoration(
                  hintText: "Start typing contents",
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
            )
          ],
        ),
      ),
    );
  }
}
