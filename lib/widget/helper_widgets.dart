import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/gvariables.dart';

Widget screenModes(ScreenModes mode, RxBool visBool, String imgUrl) {
  switch (mode) {
    case ScreenModes.loading:
      return Visibility(
          visible: visBool.value,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const CircularProgressIndicator()),
          ));
    default:
      return Visibility(
          visible: visBool.value,
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(imgUrl),
          ));
  }
}
