import 'dart:convert';

import 'package:noteapp_localstorage_notification/constatnts/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/note_model.dart';

String noteKey = 'note';

class NoteStorage {
  static Future<bool> saveNotes(List<NoteModel> notes) async {
    final prefs = await SharedPreferences.getInstance();

    // final encNote = notes.map((e) => jsonEncode(e.toMap())).toList();
    // encNote = List<String>
    //  bool isSaved = await prefs.setStringList(noteKey, encNote);
    final encodedNote = notes.map((e) => e.toMap()).toList();
    var code = jsonEncode(encodedNote);
    bool isSaved = await prefs.setString(noteKey, code);
    return isSaved;
  }

  static Future<List<NoteModel>> retrieveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<NoteModel> convertedNote = [];
    final theNote = prefs.getString(noteKey);
    if (theNote != null) {
      final theJson = jsonDecode(theNote) as List<dynamic>;
      convertedNote = theJson.map((e) => NoteModel.fromMap(e)).toList();
      notes = convertedNote; //tocheck
    }

    return convertedNote;
  }

  static editNote(int index) async {}

  // static deleteNote(int index) async {
  //   notes.removeAt(index);
  //   saveNotes(notes);
  // }

  static deleteNote(int index) async {
    notes.removeWhere((element) => element.id == notes[index].id);
    saveNotes(notes);
    retrieveNotes();
  }

  static bulkDelete() {
    for (var element in selectedNotes) {
      deleteNote(element.id);
    }
    startSelecting = false;
    selectedNotes = []; //to redo with setstate in home
  }
}
