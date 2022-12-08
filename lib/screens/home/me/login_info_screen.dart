import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
import 'package:get/get.dart';

class LoginInfoScreen extends StatefulWidget {
  const LoginInfoScreen({Key? key}) : super(key: key);

  @override
  State<LoginInfoScreen> createState() => _LoginInfoScreenState();
}

class _LoginInfoScreenState extends State<LoginInfoScreen> {
  var usernameController = TextEditingController();
  var phoneController = TextEditingController();
  var otpController = TextEditingController();
  var oldPassController = TextEditingController();
  var newPassController = TextEditingController();
  var repeatPassController = TextEditingController();
  final passFormkey = GlobalKey<FormState>();
  bool emailRead = true;
  bool phoneRead = true;

  @override
  void initState() {
    usernameController.text = GlobalVariables.userName;
    // phoneController.text = GlobalVariables.phoneNumber;
    super.initState();
  }

  changePassword() {
//     user login hiij orchihood password solih
// PUT
// {{LOCAL}}/user/password?old=81dc9bdb52d04dc20036dbd8313ed055&new=e034fb6b66aacc1d48f445ddfb08da98
    var oldBytes = utf8.encode(oldPassController.text);
    var oldPass = md5.convert(oldBytes);
    var newBytes = utf8.encode(newPassController.text);
    var newPass = md5.convert(newBytes);

    String url = '${CoreUrl.crowdfund}user/password?old=$oldPass&new=$newPass';
    Services().putRequest(json.encode({}), url, true, '').then((data) {
      if (data.statusCode == 200) {
        oldPassController.text = "";
        newPassController.text = "";
        repeatPassController.text = "";
        Get.snackbar(
          'success_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.2),
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CoreColor().backgroundBtnBlue,
        title: const Text('Нэвтрэх мэдээлэл'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Нэвтрэх нэр"),
              const SizedBox(height: 10),
              TextFormField(
                autofocus: false,
                readOnly: emailRead,
                keyboardType: TextInputType.text,
                controller: usernameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  suffixIcon: emailRead == true
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              emailRead = false;
                            });
                          },
                          icon: const Icon(
                            Icons.edit,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              emailRead = true;
                            });
                          },
                          icon: const Icon(
                            Icons.change_circle_outlined,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                  filled: true,
                  labelText: '',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: passFormkey,
                child: Container(
                  width: GlobalVariables.gWidth,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      width: 1,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Нууц үг шинэчлэх',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Хуучин нууц үг',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        controller: oldPassController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Талбарыг бөглөнө үү!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: '',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Шинэ нууц үг',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        autofocus: false,
                        controller: newPassController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Талбарыг бөглөнө үү!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: '',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Шинэ нууц үг давтах',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: repeatPassController,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Хоосон';
                          }
                          if (val != newPassController.text) {
                            return 'Нууц үг таарахгүй байна';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: '',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GeregeButtonWidget(
                          radius: 10.0,
                          elevation: 0.0,
                          minWidth: GlobalVariables.gWidth / 1.6,
                          backgroundColor: CoreColor().backgroundBtnBlue,
                          borderColor: CoreColor().backgroundBtnBlue,
                          text: const Text(
                            'Нууц үг солих',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (passFormkey.currentState!.validate()) {
                              changePassword();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  optDialog() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(20),
      title: "Баталгаажуулалт",
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: Colors.black),
      textConfirm: "Баталгаажуулах",
      textCancel: "Буцах",
      cancelTextColor: Colors.black,
      confirmTextColor: Colors.white,
      buttonColor: CoreColor().backgroundBtnBlue,
      barrierDismissible: false,
      radius: 10,
      content: SizedBox(
        width: GlobalVariables.gWidth - 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Нэг удаагийн код '),
            const SizedBox(height: 20),
            TextFormField(
              autofocus: false,
              keyboardType: TextInputType.text,
              controller: otpController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: '',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                contentPadding: const EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
