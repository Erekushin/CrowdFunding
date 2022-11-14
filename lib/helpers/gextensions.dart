import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/helpers/language_translation.dart';

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
