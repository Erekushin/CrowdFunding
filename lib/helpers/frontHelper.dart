import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:get/get.dart';

class FrontHelper {
  requestErrorSnackbar(var data, Function succesFunc) {
    if (data.statusCode == 200) {
      succesFunc();
    } else {
      Get.snackbar(
        'warning_tr'.translationWord(),
        '${data.body['message']}'.translationWord(),
        colorText: Colors.black,
        backgroundColor: Colors.grey.withOpacity(0.2),
      );
    }
  }
}
