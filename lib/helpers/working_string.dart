import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/helpers/language_translation.dart';
import 'package:get/get.dart';

/// string extension capitalize
extension StringExtension on String {
  /// uppercase first one string
  capitalizeCustom() {
    if (isEmpty) {
      return "";
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  ///First 3 character of string
  first3() {
    return substring(0, 3);
  }

  lastSplice3() {
    return substring(0, 5);
  }

  translationWord() {
    return TranslationWords().languageKeys[GlobalVariables.localeLong]?[this] ??
        this;
  }

  ammountCorrection() {
    String added = '';
    added = split('')
        .reversed
        .join()
        .replaceAllMapped(RegExp(r".{3}"), (match) => "${match.group(0)} ")
        .replaceAll(RegExp(' '), ',')
        .split('')
        .reversed
        .join();

    if (length % 3 == 0) {
      added = added.substring(1);
    }
    return added;
  }
}

class GlobalValidator {
  String? emailValid(String? value) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    if (regExp.hasMatch(value!) == true) {
      return null;
    } else {
      return "email_regex_tr".translationWord();
    }
  }

  String? otptext(String? value) {
    String p = r'^(([0-9]{6}))$';
    RegExp regExp = RegExp(p);
    if (regExp.hasMatch(value!) == true) {
      return null;
    } else {
      return "otp_regex_tr".translationWord();
    }
  }

  String? passValid(String? value) {
    String p = r'^(([0-9]{4}))$';
    RegExp regExp = RegExp(p);
    if (regExp.hasMatch(value!) == true) {
      return null;
    } else {
      return "otp_regex_tr".translationWord();
    }
  }

  rdValid(String? value) {
    String p = r'[а-яА-Я]{2}\d{8}$';
    RegExp regExp = RegExp(p);
    if (regExp.hasMatch(value!) == true) {
      return null;
    } else {
      Get.snackbar(
        'Болохгүй',
        "rd_regex_tr".translationWord(),
        colorText: Colors.black,
        backgroundColor: Colors.grey.withOpacity(0.2),
      );
      return "rd_regex_tr".translationWord();
    }
  }

  String? phoneValid(String? value) {
    String p = r'^(([0-9]{8}))$';
    RegExp regExp = RegExp(p);
    if (regExp.hasMatch(value!) == true) {
      return null;
    } else {
      return "phone_regex_tr".translationWord();
    }
  }
}
