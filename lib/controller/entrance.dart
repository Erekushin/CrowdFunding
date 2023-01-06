import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/global_players.dart';
import 'package:get/get.dart';

import '../helpers/backHelper.dart';
import '../helpers/core_url.dart';
import '../helpers/gvariables.dart';
import '../helpers/services.dart';
import '../helpers/working_string.dart';
import '../screens/content_home/home.dart';

class EntranceCont extends GetxController {
  final crowdlog = logger(EntranceCont);

  //#region register

  var recieverTypeVis = false.obs;
  var phoneVis = false.obs;
  var emailVis = false.obs;
  var otpVis = false.obs;
  var otpVisRecover = false.obs;
  var citizenInfoVis = false.obs;
  var loading = false.obs;

  var phoneTxt = TextEditingController();
  var emailTxt = TextEditingController();
  var otpTxt = TextEditingController();
  var passTxt = TextEditingController();
  var passVerifyTxt = TextEditingController();
  String registerText = '';

  register() async {
    getCountryList();
    loading.value = true;
    citizenInfoVis.value = true;
    var bytes = utf8.encode(passTxt.text);
    var digest = md5.convert(bytes);
    var bodyData = {
      "identity": registerText,
      "password": digest.toString(),
      "otp": otpTxt.text
    };
    await Services()
        .postRequest(bodyData, '${CoreUrl.crowdfund}auth/register', true, '')
        .then((data) {
      crowdlog.wtf(
          '---register---:body $bodyData........ data ${data.body.toString()}');
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, () {
        var res = data.body;
        GlobalVariables.gStorage
            .write("token", res['result']['authorization']['token']);
        GlobalVariables.gStorage
            .write('userInformation', res['result']['user']);
        GlobalVariables.storageToVar();
        getCountryList();
        citizenInfoVis.value = true;
        loading.value = false;
      });
    });
  }

  otpSend(String route, String value, String incomingurl) async {
    bool valid = false;
    loading.value = false;
    if (value == 'Утас') {
      phoneTxt.text = phoneTxt.text.replaceAll(' ', '');
      if (GlobalValidator().phoneValid(phoneTxt.text) == null) {
        registerText = phoneTxt.text;
        valid = true;
      } else {
        Get.snackbar(
          'Боломжгүй',
          'Утасны дугаар алдаатай байна',
          colorText: Colors.black,
          backgroundColor: Colors.grey.withOpacity(0.2),
        );
      }
    } else if (value == 'Е-Мэйл') {
      emailTxt.text = emailTxt.text.replaceAll(' ', '');
      if (GlobalValidator().emailValid(emailTxt.text) == null) {
        registerText = emailTxt.text;
        valid = true;
      } else {
        Get.snackbar(
          'Боломжгүй',
          'E-mail хаяг буруу байна!',
          colorText: Colors.black,
          backgroundColor: Colors.grey.withOpacity(0.2),
        );
      }
    }
    String url = '${CoreUrl.crowdfund}$incomingurl$registerText';
    if (route == "Бүртгүүлэх") {
      otpVis.value = false;
    } else {
      otpVisRecover.value = false;
    }
    if (valid) {
      loading.value = true;
      await Services().getRequest(url, false, '').then(
        (data) {
          crowdlog.wtf('---OTP REQ---:returned data ${data.body.toString()}');
          GlobalPlayers.frontHelper.requestErrorSnackbar(data, () {
            if (route == "Бүртгүүлэх") {
              otpVis.value = true;
            } else {
              otpVisRecover.value = true;
            }
          });
          loading.value = false;
        },
      );
    }
  }

  resetPassword() {
    loading.value = true;
    var bytes = utf8.encode(passTxt.text);
    var digest = md5.convert(bytes);
    String url =
        '${CoreUrl.crowdfund}auth/password?identity=$registerText&password=$digest&otp=${otpTxt.text}';
    Services().putRequest(json.encode({}), url, false, '').then((data) {
      crowdlog.wtf(
          '---resetPassword---:text $registerText...passOrigin: ${passTxt.text} pass: $digest....otp: ${otpTxt.text}......... data ${data.body.toString()}.....url: $url');

      GlobalPlayers.frontHelper.requestErrorSnackbar(data, () {
        Get.snackbar(
          'Амжилттай',
          'Нууц үг амжилттай шинэчлэгдлээ',
          colorText: Colors.black,
          backgroundColor: Colors.grey.withOpacity(0.2),
        );
        Get.to(() => const ContentHome());
        loading.value = false;
      });
    });
  }

  //#endregion

  //#region login
  TextEditingController searchText = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  late String currentTimeZone;

  void loginUser() async {
    var bytes = utf8.encode(passwordTextController.text);
    var digest = md5.convert(bytes);
    var bodyData = {
      "username": searchText.text,
      "password": digest.toString(),
      "device_token": GlobalVariables.deviceToken,
    };

    if (GlobalValidator().emailValid(searchText.text) == null &&
        GlobalValidator().phoneValid(searchText.text) == null) {
      Services()
          .postRequest(json.encode(bodyData), '${CoreUrl.crowdfund}auth/login',
              false, '')
          .then((data) {
        var res = data.body;
        crowdlog.wtf(
            '---LOGIN---: sent data $bodyData:.................returned data ${data.body.toString()}');
        GlobalPlayers.frontHelper.requestErrorSnackbar(data, () {
          if (GlobalVariables.ifFingering == true &&
              GlobalVariables.pass == '') {
            GlobalPlayers.workingWithFile.addNewItem('isFingering', 'true');
            GlobalPlayers.workingWithFile
                .addNewItem('pass', passwordTextController.text);
            GlobalPlayers.workingWithFile.addNewItem('name', searchText.text);
          }
          GlobalVariables.gStorage
              .write("token", res['authorization']['token']);
          GlobalVariables.gStorage.write('userInformation', res['user']);
          GlobalVariables.storageToVar();
          searchText.clear();
          passwordTextController.clear();
          Get.to(() => const ContentHome());
        });
      });
    } else {
      Get.snackbar(
        'Боломжгүй',
        'Нэвтрэх нэр буруу байна',
        colorText: Colors.black,
        backgroundColor: Colors.grey.withOpacity(0.2),
      );
    }
  }

  //#endregion

  //#region helper funcs

  var rdtxt = TextEditingController();
  var lastNameController = TextEditingController();
  var firstNameController = TextEditingController();
  var docNoController = TextEditingController();

  String birthday = '';
  String givenDay = '';
  String expiredDay = '';

  Future documentFind(BuildContext context, String selectionCountry,
      String selectionGender) async {
    rdtxt.text = rdtxt.text.replaceAll(' ', '');
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
    if (GlobalValidator().rdValid(rdtxt.text) == null) {
      await Services()
          .postRequest(
              json.encode(selectionCountry == "MNG" ? bodyMNG : bodyOther),
              '${CoreUrl.crowdfund}document/find',
              true,
              '')
          .then((data) {
        crowdlog.wtf(
            '---findDocument---:selectedCountry: $selectionCountry.... body: $bodyMNG....returned data ${data.body.toString()}');
        GlobalPlayers.frontHelper.requestErrorSnackbar(data, () {
          Get.snackbar(
            'Амжилттай',
            'Мэдээллийг амжилттай хавсрагалаа',
            colorText: Colors.black,
            backgroundColor: Colors.grey.withOpacity(0.2),
          );
          Get.to(() => const ContentHome());
        });
      });
    } else {
      Get.snackbar(
        'Боломжгүй',
        'Регистрийн дугаар алдаатай байна!',
        colorText: Colors.black,
        backgroundColor: Colors.grey.withOpacity(0.2),
      );
    }
  }

  RxList countryList = [].obs;
  getCountryList() {
    loading.value = true;
    String url = '${CoreUrl.crowdfund}countries?page_size=500&page_number=1';
    Services().getRequest(url, true, '').then((data) {
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, () {
        countryList.value = data.body['result']['items'];
      });
      loading.value = false;
    });
  }

  //#endregion
}
