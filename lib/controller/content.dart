import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:get/state_manager.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';

import '../helpers/core_url.dart';
import '../helpers/gvariables.dart';
import '../helpers/logging.dart';
import '../screens/content_home/home.dart';
import '../services/get_service.dart';

class ContentCont extends GetxController {
  final crowdlog = logger(ContentCont);
  Future getListData(BuildContext context) async {
    Services().getRequest('${CoreUrl.crowdfund}crowd', true, '').then((data) {
      Navigator.of(Get.overlayContext!).pop();
      var res = data.body;
      crowdlog.wtf(
          '---GET PROJECT LIST---:TOKEN: ${GlobalVariables.gStorage.read("token")}.................returned data ${data.body.toString()}');
      if (data.statusCode == 200) {
        // Get.back();

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
}
