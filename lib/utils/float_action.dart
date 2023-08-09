import 'package:flutter/material.dart';

FloatButton({required VoidCallback onPressed, required icon}) {
  return FloatingActionButton(
    backgroundColor: Colors.amberAccent,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    onPressed: onPressed,
    child: Icon(
      icon,
      size: 30,
      color: Colors.white,
      shadows: const [
        Shadow(color: Colors.grey, offset: Offset(-1, -1)),
      ],
    ),
  );
}
