import 'package:flutter/material.dart';
import 'package:CrowdFund/helpers/working_string.dart';
import 'package:get/get.dart';

import '../global_players.dart';

Object successSnack(String text) {
  return Get.snackbar('success_tr'.translationWord(), '',
      messageText: Text(
        text.translationWord(),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: Colors.greenAccent,
      icon: const Icon(Icons.check),
      duration: Duration(seconds: Sizes.regularSnackDuration));
}

Object warningSnack(String text) {
  return Get.snackbar('warning_tr'.translationWord(), '',
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

Object errorSnack(String text) {
  return Get.snackbar('error_tr'.translationWord(), '',
      messageText: Text(
        text.translationWord(),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: Colors.redAccent,
      icon: const Icon(Icons.warning),
      duration: Duration(seconds: Sizes.regularSnackDuration));
}
