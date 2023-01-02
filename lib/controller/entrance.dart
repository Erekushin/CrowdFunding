import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:get/get.dart';

import '../helpers/core_url.dart';
import '../helpers/gvariables.dart';
import '../helpers/logging.dart';
import '../services/get_service.dart';

class Entrance extends GetxController {
  final crowdlog = logger(Entrance);
  //#region box visibility switcher booleans

  var recieverTypeVis = false.obs;
  var phoneVis = false.obs;
  var emailVis = false.obs;
  var otpVis = false.obs;
  var citizenInfoVis = false.obs;

  //#endregion

  //#region register info
  var phoneTxt = TextEditingController();
  var emailTxt = TextEditingController();
  String registerText = '';
  var otpTxt = TextEditingController();
  var passTxt = TextEditingController();
  var passVerifyTxt = TextEditingController();
  //#endregion

  var rdtxt = TextEditingController();
  var lastNameController = TextEditingController();
  var firstNameController = TextEditingController();

  var docNoController = TextEditingController();

  String birthday = '';
  String givenDay = '';
  String expiredDay = '';
  Future<Response> documentFind(BuildContext context, String selectionCountry,
      String selectionGender) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var bodyMNG = {
      "country_code": selectionCountry,
      "reg_no": rdtxt.text,
    };
    var bodyOther = {
      "birth_date": birthday,

      "country_code": selectionCountry,
      "date_of_expiry": expiredDay,
      "date_of_issue": givenDay,
      "document_number": docNoController.text,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "reg_no": "",
      "type_id": "",
      "category_id": "4", //selectCategoryId,

      "gender": selectionGender == "Эр" ? "1" : "0"
    };

    final response = await Services().postRequest(
        json.encode(selectionCountry == "MNG" ? bodyMNG : bodyOther),
        '${CoreUrl.crowdfund}document/find',
        true,
        '');
    Get.back();
    return response;
  }

  otpSend(String value) async {
    otpVis.value = true;
    // if (value == 'Утас') {
    //   registerText = phoneTxt.text;
    // } else {
    //   registerText = emailTxt.text;
    // }

    // String url = '${CoreUrl.crowdfund}auth/identify?text=$registerText';
    // await Services().getRequest(url, false, '').then(
    //   (data) {
    //     crowdlog.wtf('---OTP REQ---:returned data ${data.body.toString()}');
    //     if (data.statusCode == 200) {
    //       otpVis.value = true;
    //     } else {
    //       Get.snackbar(
    //         'warning_tr'.translationWord(),
    //         data.body['message'],
    //         colorText: Colors.white,
    //         backgroundColor: Colors.grey.withOpacity(0.2),
    //       );
    //     }
    //   },
    // );
  }

  register() async {
    getCountryList();
    citizenInfoVis.value = true;
    // var bytes = utf8.encode(passTxt.text);
    // var digest = md5.convert(bytes);
    // var bodyData = {
    //   "identity": registerText,
    //   "password": digest.toString(),
    //   "otp": otpTxt.text
    // };
    // await Services()
    //     .postRequest(bodyData, '${CoreUrl.crowdfund}auth/register', true, '')
    //     .then((data) {
    //   crowdlog.wtf(
    //       '---register---:body $bodyData........ data ${data.body.toString()}');
    //   switch (data.statusCode) {
    //     case 200:
    //       var res = data.body;
    //       GlobalVariables.gStorage
    //           .write("token", res['result']['authorization']['token']);
    //       GlobalVariables.gStorage
    //           .write('userInformation', res['result']['user']);
    //       GlobalVariables.storageToVar();
    //       getCountryList();
    //       citizenInfoVis.value = true;
    //       break;
    //     case 500:
    //       Get.snackbar(
    //         'warning_tr'.translationWord(),
    //         data.body['message'],
    //         colorText: Colors.black,
    //         backgroundColor: Colors.grey.withOpacity(0.2),
    //       );
    //       break;
    //     default:
    //   }
    // });
  }

  RxList countryList = [].obs;
  getCountryList() {
    String url = '${CoreUrl.crowdfund}countries?page_size=500&page_number=1';
    Services().getRequest(url, true, '').then((data) {
      if (data.statusCode == 200) {
        countryList.value = data.body['result']['items'];
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: Colors.red.withOpacity(0.2),
        );
      }
    });
  }
}
