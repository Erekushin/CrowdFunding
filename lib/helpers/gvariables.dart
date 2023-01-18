import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/services.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum ScreenModes { loading, noProject, noInternet, error, data }

class GlobalVariables {
  var userInfo;
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
  static GetStorage gStorage = GetStorage();
  static String deviceToken = '';
  static String localeLong = '';

  /// user information data start
  static String id = "";
  static String civilId = '';
  static String regNo = 'Регистрийн дугаар';
  static String familyName = '';
  static String lastName = '';
  static String firstName = '';
  static String userName = '';
  static String rootAccount = "";
  static String email = '';
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
    var userInformation = gStorage.read('userInformation');

    GlobalVariables.id = gStorage.read('userInformation')['id'] ?? '';
    GlobalVariables.civilId =
        gStorage.read('userInformation')['civil_id'] ?? '';
    GlobalVariables.regNo = gStorage.read('userInformation')['reg_no'] ?? '';
    GlobalVariables.familyName =
        gStorage.read('userInformation')['family_name'] ?? '';
    GlobalVariables.lastName =
        gStorage.read('userInformation')['last_name'] ?? '';
    GlobalVariables.firstName =
        gStorage.read('userInformation')['first_name'] ?? '';
    GlobalVariables.userName =
        gStorage.read('userInformation')['username'] ?? '';
    GlobalVariables.rootAccount =
        gStorage.read('userInformation')['root_account'] ?? '';
    GlobalVariables.email = gStorage.read('userInformation')['email'] ?? '';
    GlobalVariables.phoneNumber =
        gStorage.read('userInformation')['phone_no'] ?? '';
    GlobalVariables.gender = gStorage.read('userInformation')['gender'] ?? 0;
    GlobalVariables.birthDate =
        gStorage.read('userInformation')['birth_date'] ?? '';
    GlobalVariables.isForeign =
        gStorage.read('userInformation')['is_foreign'] ?? '';
    GlobalVariables.aimagCode =
        gStorage.read('userInformation')['aimag_code'] ?? '';
    GlobalVariables.aimagName =
        gStorage.read('userInformation')['aimag_name'] ?? '';
    GlobalVariables.sumCode =
        gStorage.read('userInformation')['sum_code'] ?? '';
    GlobalVariables.sumName =
        gStorage.read('userInformation')['sum_name'] ?? '';
    GlobalVariables.bagCode =
        gStorage.read('userInformation')['bag_code'] ?? '';
    GlobalVariables.bagName =
        gStorage.read('userInformation')['bag_name'] ?? '';
    GlobalVariables.address = gStorage.read('userInformation')['address'] ?? '';
    GlobalVariables.profileImage.value =
        gStorage.read('userInformation')['profile_image'] ?? '';
    GlobalVariables.countryCode =
        gStorage.read('userInformation')['country_code'] ?? '';
    GlobalVariables.countryName =
        gStorage.read('userInformation')['country_name'] ?? '';
    GlobalVariables.nationality =
        gStorage.read('userInformation')['nationality'] ?? '';
    GlobalVariables.countryNameEn =
        gStorage.read('userInformation')['country_name_en'] ?? '';
    GlobalVariables.cLevel = gStorage.read('userInformation')['c_level'] ?? 0;
    GlobalVariables.isConfirmedPhone =
        gStorage.read('userInformation')['is_confirmed_phone_no'] ?? 0;
    GlobalVariables.isConfirmedEmail =
        gStorage.read('userInformation')['is_confirmed_email'] ?? 0;
  }

  ///[updateUserInformation] update user information
  static updateUserInformation() {
    String url =
        '${CoreUrl.crowdfund}user/find?search_text=${GlobalVariables.id}';
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
