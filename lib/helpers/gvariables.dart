import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GlobalVariables {
  static bool useTablet = false;
  static String usePos = "";
  static RxBool isTabletSidebar = true.obs;
  static double gWidth = Get.width;
  static double gHeight = Get.height;
  static GetStorage gStorage = GetStorage();
  static String deviceToken = '';
  static String localeLong = '';

  /// user information data start
  static String id = "";
  static String civilId = '';
  static String regNo = '';
  static String familyName = '';
  static String lastName = '';
  static String firstName = '';
  static String userName = '';
  static String rootAccount = "";
  static RxString email = ''.obs;
  static String phoneNumber = '';
  static int gender = 0;
  static String birthDate = '';
  static int isForeign = 0;
  static String aimagCode = '';
  static String aimagName = '';
  static String sumCode = '';
  static String sumName = '';
  static String bagCode = '';
  static String bagName = '';
  static String address = '';
  static RxString profileImage = ''.obs;
  static String countryCode = '';
  static String countryName = '';
  static String nationality = '';
  static String countryNameEn = '';
  static int cLevel = 0;
  static int isConfirmedPhone = 0;
  static int isConfirmedEmail = 0;
  static RxInt accountBalance = 1.obs;
  static List accountNoList = [];

  /// [storageToVar] user variables assign a value
  static storageToVar() {
    var userInformation = GlobalVariables.gStorage.read('userInformation');

    GlobalVariables.id = userInformation['id'] ?? '';
    GlobalVariables.civilId = userInformation['civil_id'] ?? '';
    GlobalVariables.regNo = userInformation['reg_no'] ?? '';
    GlobalVariables.familyName = userInformation['family_name'] ?? '';
    GlobalVariables.lastName = userInformation['last_name'] ?? '';
    GlobalVariables.firstName = userInformation['first_name'] ?? '';
    GlobalVariables.userName = userInformation['username'] ?? '';
    GlobalVariables.rootAccount = userInformation['root_account'] ?? '';
    GlobalVariables.email.value = userInformation['email'] ?? '';
    GlobalVariables.phoneNumber = userInformation['phone_no'] ?? '';
    GlobalVariables.gender = userInformation['gender'] ?? 0;
    GlobalVariables.birthDate = userInformation['birth_date'] ?? '';
    GlobalVariables.isForeign = userInformation['is_foreign'] ?? '';
    GlobalVariables.aimagCode = userInformation['aimag_code'] ?? '';
    GlobalVariables.aimagName = userInformation['aimag_name'] ?? '';
    GlobalVariables.sumCode = userInformation['sum_code'] ?? '';
    GlobalVariables.sumName = userInformation['sum_name'] ?? '';
    GlobalVariables.bagCode = userInformation['bag_code'] ?? '';
    GlobalVariables.bagName = userInformation['bag_name'] ?? '';
    GlobalVariables.address = userInformation['address'] ?? '';
    GlobalVariables.profileImage.value = userInformation['profile_image'] ?? '';
    GlobalVariables.countryCode = userInformation['country_code'] ?? '';
    GlobalVariables.countryName = userInformation['country_name'] ?? '';
    GlobalVariables.nationality = userInformation['nationality'] ?? '';
    GlobalVariables.countryNameEn = userInformation['country_name_en'] ?? '';
    GlobalVariables.cLevel = userInformation['c_level'] ?? 0;
    GlobalVariables.isConfirmedPhone =
        userInformation['is_confirmed_phone_no'] ?? 0;
    GlobalVariables.isConfirmedEmail =
        userInformation['is_confirmed_email'] ?? 0;
  }

  ///[updateUserInformation] update user information
  static updateUserInformation() {
    String url =
        '${CoreUrl.serviceUrl}user/find?search_text=${GlobalVariables.id}';
    Services().getRequest(url, true, '').then((data) {
      if (data.statusCode == 200) {
        GlobalVariables.gStorage.write('userInformation', data.body['result']);
        storageToVar();
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
