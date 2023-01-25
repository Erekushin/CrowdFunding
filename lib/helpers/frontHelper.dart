// ignore: file_names
import 'package:flutter/material.dart';

import '../dialogs/snacks.dart';

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
            ? somethingIsWrongSnack(
                'something_is_wrong_tr', data.body['message'])
            : snackAppearance == 2
                ? requestErrorSnackbar2(data, failedFunc)
                : failedFunc();
      }
    } catch (e) {
      snackAppearance == 1 ? errorSnack('error_tr_body') : failedFunc();
    }
  }

  requestErrorSnackbar2(var data, Function failedFunc) {
    try {
      somethingIsWrongSnack('something_is_wrong_tr', data.body['message']);
      failedFunc();
    } catch (e) {
      errorSnack('error_tr_body');
      failedFunc();
    }
  }
}

class MyscrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
