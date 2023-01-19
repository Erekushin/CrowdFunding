import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/services.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../global_players.dart';

enum ScreenModes { loading, noProject, noInternet, error, data }

class GlobalVariables {
  static Map userInfo = {
    "id": "",
    "civil_id": "",
    "reg_no": "",
    "family_name": "",
    "last_name": "",
    "first_name": "",
    "username": "",
    "root_account": "",
    "email": "",
    "phone_no": "",
    "gender": 1,
    "birth_date": "",
    "is_foreign": 0,
    "aimag_code": "",
    "aimag_name": "",
    "sum_code": "",
    "sum_name": "",
    "bag_code": "",
    "bag_name": "",
    "address": "",
    "profile_image": "",
    "country_code": "",
    "country_name": "",
    "nationality": "",
    "country_name_en": "",
    "c_level": 0,
    "created_date": "",
    "updated_date": "",
    "is_confirmed_phone_no": 0,
    "is_confirmed_email": 1
  };
  static var token;
  static bool ifFingering = false;
  static String pass = '';
  static String name = '';
  GlobalVariables.fingerLoginfo(Map<String, dynamic> json) {
    if (json['isFingering'] == null) {
      ifFingering = false;
    } else {
      if (json['isFingering'] == 'true') {
        ifFingering = true;
      } else if (json['isFingering'] == 'false') {
        ifFingering = false;
      } else {
        ifFingering = false;
      }
    }
    pass = json['pass'] ?? '';
    name = json['name'] ?? '';
  }

  static bool useTablet = false;
  static String usePos = "";
  static RxBool isTabletSidebar = true.obs;
  static double gWidth = Get.width;
  static double gHeight = Get.height;
  static String deviceToken = '';
  static String localeLong = '';

  static RxInt accountBalance = 1.obs;
  static List accountNoList = [];

  ///[updateUserInformation] update user information
  static updateUserInformation() {
    String url =
        '${CoreUrl.crowdfund}user/find?search_text=${GlobalVariables.userInfo['id']}';
    Services().getRequest(url, true, '').then((data) {
      if (data.statusCode == 200) {
        userInfo = data.body['result'];
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: Colors.white,
        );
      }
    });
  }

  static bool keyboardIsVisible(BuildContext context) {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  static String moneyFormat(String price) {
    if (price.length >= 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
    return "";
  }
}
