import 'package:flutter/material.dart';
// import 'package:note_app/model/category_model.dart';

void showAlert(
    {required BuildContext context,
    required TextEditingController titleC,
    required TextEditingController descriptionC,
    required VoidCallback onPressed}) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleC,
              decoration: const InputDecoration(hintText: "Title"),
            ),
            TextField(
              controller: descriptionC,
              decoration: const InputDecoration(hintText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel")),
          TextButton(onPressed: onPressed, child: const Text("Add"))
        ],
      );
    },
  );
}

// void showEditAlert({
//   required BuildContext context,
//   required TextEditingController titleEditC,
//   required TextEditingController descriptionEditC,
//   required VoidCallback onPressed,
// }) async {
//   return await showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleEditC,
//               decoration: const InputDecoration(hintText: "Title"),
//             ),
//             TextField(
//               controller: descriptionEditC,
//               decoration: const InputDecoration(hintText: "Description"),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancel")),
//           TextButton(onPressed: onPressed, child: const Text("Edit"))
//         ],
//       );
//     },
//   );
// }
