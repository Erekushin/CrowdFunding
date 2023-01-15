import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:get/get.dart';

class FrontHelper {
  ///серверээс ирж байгаа датаг [data] аар авч байгаа
  /// [snackAppearance] дээр 1 бол snacbar харагдана 2 бол snackbar аас гадна func аар үйлдэл хийнэ бусад үед зөвхөн үйлдэл хийнэ
  /// [succesFunc] амжилттай үеийн үйлдэл [failedFunc] амжилтгүй үеийн үйлдэл
  requestErrorSnackbar(
      var data, int snackAppearance, Function succesFunc, Function failedFunc) {
    try {
      if (data.statusCode == 200) {
        succesFunc();
      } else {
        snackAppearance == 1
            ? Get.snackbar(
                'warning_tr'.translationWord(),
                '${data.body['message']}'.translationWord(),
                colorText: Colors.black,
                backgroundColor: Colors.grey.withOpacity(0.2),
              )
            : snackAppearance == 2
                ? requestErrorSnackbar2(data, failedFunc)
                : failedFunc();
      }
    } catch (e) {
      snackAppearance == 1
          ? Get.snackbar(
              'Уучлаарай',
              'ямар нэгэн алдаа гарлаа',
              colorText: Colors.black,
              backgroundColor: Colors.grey.withOpacity(0.2),
            )
          : failedFunc();
    }
  }

  requestErrorSnackbar2(var data, Function failedFunc) {
    try {
      Get.snackbar(
        'warning_tr'.translationWord(),
        '${data.body['message']}'.translationWord(),
        colorText: Colors.black,
        backgroundColor: Colors.grey.withOpacity(0.2),
      );
      failedFunc();
    } catch (e) {
      Get.snackbar(
        'Уучлаарай',
        'ямар нэгэн алдаа гарлаа',
        colorText: Colors.black,
        backgroundColor: Colors.grey.withOpacity(0.2),
      );
      failedFunc();
    }
  }
}
