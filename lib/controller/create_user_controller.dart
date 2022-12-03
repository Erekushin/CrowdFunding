import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';

class CreateUserController extends GetxController {
  TextEditingController? searchController;
  TextEditingController? otpCodeController;
  TextEditingController? passwordController;
  TextEditingController? registerController;
  TextEditingController? lastNameController;
  TextEditingController? firstNameController;
  TextEditingController? yearBirth;
  TextEditingController? monthBirth;
  TextEditingController? dayBirth;
  TextEditingController? docNoController;
  TextEditingController? yearIssue;
  TextEditingController? monthIssue;
  TextEditingController? dayIssue;
  TextEditingController? yearExpire;
  TextEditingController? monthExpire;
  TextEditingController? dayExpire;

  @override
  void onInit() {
    searchController = TextEditingController();
    otpCodeController = TextEditingController();
    passwordController = TextEditingController();
    registerController = TextEditingController();
    lastNameController = TextEditingController();
    firstNameController = TextEditingController();
    yearBirth = TextEditingController();
    monthBirth = TextEditingController();
    dayBirth = TextEditingController();
    docNoController = TextEditingController();
    yearIssue = TextEditingController();
    monthIssue = TextEditingController();
    dayIssue = TextEditingController();
    yearExpire = TextEditingController();
    monthExpire = TextEditingController();
    dayExpire = TextEditingController();
    super.onInit();
  }

  Future<Response> otpSend(BuildContext context) async {
    String url =
        '${CoreUrl.serviceUrl}auth/identify?text=${searchController!.text}';
    final response = await Services().getRequest(url, false, '');
    return response;
  }

  Future<Response> register(BuildContext context) async {
    var bytes = utf8.encode(passwordController!.text);
    var digest = md5.convert(bytes);
    var bodyData = {
      "identity": searchController!.text,
      "password": digest.toString(),
      "otp": otpCodeController!.text
    };
    final response = await Services()
        .postRequest(bodyData, '${CoreUrl.serviceUrl}auth/register', false, '');
    if (response.statusCode == 200) {
      var res = response.body;
      GlobalVariables.gStorage
          .write("token", res['result']['authorization']['token']);
      GlobalVariables.gStorage.write('userInformation', res['result']['user']);
      GlobalVariables.storageToVar();
    }
    return response;
  }

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
      "reg_no": registerController!.text,
    };
    var bodyOther = {
      "birth_date": yearBirth!.text == ""
          ? ''
          : "${yearBirth!.text}-${monthBirth!.text}-${dayBirth!.text}",

      "country_code": selectionCountry,
      "date_of_expiry":
          "${yearExpire!.text}-${monthExpire!.text}-${dayExpire!.text}",
      "date_of_issue":
          "${yearIssue!.text}-${monthIssue!.text}-${dayIssue!.text}",
      "document_number": docNoController!.text,
      "first_name": firstNameController!.text,
      "last_name": lastNameController!.text,
      "reg_no": "",
      "type_id": "",
      "category_id": "4", //selectCategoryId,

      "gender": selectionGender == "Эр" ? "1" : "0"
    };

    final response = await Services().postRequest(
        json.encode(selectionCountry == "MNG" ? bodyMNG : bodyOther),
        '${CoreUrl.serviceUrl}document/find',
        true,
        '');
    Get.back();
    return response;
  }

  cleanSearch() {
    searchController?.text = '';
  }
}
