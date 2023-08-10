// import 'package:flutter/material.dart';

// import 'model.dart';

// class HomePage extends StatelessWidget {
//   final List<Note> notes;
//   final Function(int) onTapNote;
//   final Function() onAddNote;

//   const HomePage({
//     Key? key,
//     required this.notes,
//     required this.onTapNote,
//     required this.onAddNote,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notes'),
//       ),
//       body: ListView.builder(
//         itemCount: notes.length,
//         itemBuilder: (context, index) {
//           final note = notes[index];
//           return ListTile(
//             title: Text(note.title),
//             subtitle: Text(note.content),
//             onTap: () => onTapNote(index),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: onAddNote,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
