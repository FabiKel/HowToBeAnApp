import 'package:flutter/material.dart';

class Snacker {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(
    BuildContext context,
    String text,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(10),
        content: Text(text),
      ),
    );
  }
}
