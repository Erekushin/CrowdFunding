import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/main_tab.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';

class LoginController extends GetxController {
  TextEditingController? searchText;
  TextEditingController? passwordTextController;
  TextEditingController? deviceIdTextController;
  TextEditingController? mobileTypeTextController;
  late String currentTimeZone;
  // UserModel? userData;

  @override
  void onInit() {
    searchText = TextEditingController();
    passwordTextController = TextEditingController();
    deviceIdTextController = TextEditingController();
    mobileTypeTextController = TextEditingController();
    super.onInit();
  }

  void loginUser(BuildContext context, type) async {
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
            json.encode(bodyData), '${CoreUrl.serviceUrl}auth/login', false, '')
        .then((data) {
      Navigator.of(Get.overlayContext!).pop();
      var res = data.body;
      if (data.statusCode == 200) {
        print('login resss');
        print(res);
        // Get.back();
        GlobalVariables.gStorage.write("token", res['authorization']['token']);
        GlobalVariables.gStorage.write('userInformation', res['user']);
        GlobalVariables.storageToVar();
        // Get.to(() => const HomeScreen());
        Get.to(() => const MainTab(indexTab: 0));
      } else {
        // Get.back();
        print("wtf");
        print(res);
        Get.snackbar(
          'warning_tr'.translationWord(),
          res['message'].toString(),
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
      }
      // print(data.body['authorization']['token']);

      // log(data.body);
    });
  }

  // @override
  // void onClose() {
  //   searchText?.dispose();
  //   passwordTextController?.dispose();
  //   deviceIdTextController?.dispose();
  //   mobileTypeTextController?.dispose();
  //   super.onClose();
  // }

  clean() {
    searchText?.text = '';
    passwordTextController?.text = '';
    deviceIdTextController?.text = '';
    mobileTypeTextController?.text = '';
  }
}
