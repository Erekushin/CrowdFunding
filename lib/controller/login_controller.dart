import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';

import '../global_players.dart';
import '../helpers/logging.dart';
import '../screens/content_home/home.dart';

class LoginController extends GetxController {
  final crowdlog = logger(LoginController);
  TextEditingController? searchText;
  TextEditingController? passwordTextController;
  TextEditingController? deviceIdTextController;
  TextEditingController? mobileTypeTextController;
  late String currentTimeZone;

  @override
  void onInit() {
    searchText = TextEditingController();
    passwordTextController = TextEditingController();
    deviceIdTextController = TextEditingController();
    mobileTypeTextController = TextEditingController();
    super.onInit();
  }

  void loginUser() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var bytes = utf8.encode(passwordTextController!.text);
    var digest = md5.convert(bytes);
    var bodyData = {
      "username": searchText?.text,
      "password": digest.toString(),
      "device_token": GlobalVariables.deviceToken,
    };

    Services()
        .postRequest(
            json.encode(bodyData), '${CoreUrl.crowdfund}auth/login', false, '')
        .then((data) {
      Navigator.of(Get.overlayContext!).pop();
      var res = data.body;
      crowdlog.wtf(
          '---LOGIN---: sent data $bodyData:.................returned data ${data.body.toString()}');
      try {
        switch (data.statusCode) {
          case 200:
            if (GlobalVariables.ifFingering == true &&
                GlobalVariables.pass == '') {
              GlobalPlayers.workingWithFile.addNewItem('isFingering', 'true');
              GlobalPlayers.workingWithFile
                  .addNewItem('pass', passwordTextController!.text);
              GlobalPlayers.workingWithFile
                  .addNewItem('name', searchText!.text);
            }
            GlobalVariables.gStorage
                .write("token", res['authorization']['token']);
            GlobalVariables.gStorage.write('userInformation', res['user']);
            GlobalVariables.storageToVar();
            // Get.to(() => const MainTab(indexTab: 0));
            searchText?.clear();
            passwordTextController?.clear();
            Get.to(() => const ContentHome());
            break;
          default:
            Get.snackbar(
              'warning_tr'.translationWord(),
              res['message'].toString(),
              backgroundColor: Colors.white60,
              colorText: Colors.black,
            );
            break;
        }
      } catch (e) {
        Get.snackbar(
          'warning_tr'.translationWord(),
          e.toString(),
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
      }
    });
  }

  clean() {
    searchText?.text = '';
    passwordTextController?.text = '';
    deviceIdTextController?.text = '';
    mobileTypeTextController?.text = '';
  }
}
