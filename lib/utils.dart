import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, Color bgColor) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: bgColor, behavior: SnackBarBehavior.floating);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}