import 'dart:js';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/note_model.dart';

bool isEditing = false;
bool startSelecting = false;
bool? isListView = false;
bool isSearching = false;
int selectedIndex = -1;
List<NoteModel> notes = [];
List<NoteModel> searchNotes = [];
List<NoteModel> selectedNotes = [];
TextStyle title = GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.normal);
TextStyle content =
    GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.normal);

class Const {
  static double _height = MediaQuery.of(context as BuildContext).size.height;
  static double _width = MediaQuery.of(context as BuildContext).size.width;

  get height => _height;
  get width => _width;

  set setHeight(newH) => _height = newH;
  set setWidth(newH) => _width = newH;
}
