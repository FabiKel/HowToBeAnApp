import 'package:flutter/material.dart';

abstract class NotImplemented {
  static void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(10),
        content: const Text("Diese Option ist leider noch nicht implementiert"),
      ),
    );
  }
}
