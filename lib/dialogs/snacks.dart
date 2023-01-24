import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:get/get.dart';

import '../global_players.dart';

Object warningSnack(String title, String text) {
  return Get.snackbar(title.translationWord(), '',
      messageText: Text(
        text.translationWord(),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: Colors.yellowAccent,
      icon: const Icon(Icons.error),
      duration: Duration(seconds: Sizes.regularSnackDuration));
}

Object somethingIsWrongSnack(String title, String text) {
  return Get.snackbar(title.translationWord(), '',
      messageText: Text(
        text.translationWord(),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: Colors.orangeAccent,
      icon: const Icon(Icons.warning),
      duration: Duration(seconds: Sizes.regularSnackDuration));
}

Object errorSnack(String title, String text) {
  return Get.snackbar(title.translationWord(), '',
      messageText: Text(
        text.translationWord(),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: Colors.redAccent,
      icon: const Icon(Icons.warning),
      duration: Duration(seconds: Sizes.regularSnackDuration));
}
