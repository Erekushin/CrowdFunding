import 'dart:async';
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

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with TickerProviderStateMixin {
  var searchController = TextEditingController();
  RxBool screenChange = false.obs;

  var registerController = TextEditingController();
  var otpCodeController = TextEditingController();
  var passwordController = TextEditingController();
  late TabController tabController;

  int resendSecond = 60;
  int selectedIndex = 0;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {
        if (tabController.indexIsChanging) {
        } else {
          setState(() {
            selectedIndex = tabController.index;
          });
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  otpSend() {
    screenChange.value = true;
    // String url =
    //     '${CoreUrl.serviceUrl}/auth/password?identity=${searchController.text}';
    // Services().getRequest(url, false, '').then((data) {
    //   if (data.statusCode == 200) {
    //     print("uccress ");
    //     screenChange.value = true;
    //   } else {
    //     Get.snackbar(
    //       'warning_tr'.translationWord(),
    //       data.body['message'],
    //       colorText: Colors.white,
    //       backgroundColor: Colors.red.withOpacity(0.2),
    //     );
    //   }
    // });
  }

  resetPassword() {
    var bodyData = {
      // "identity": searchController.text,
      // "password": passwordController.text,
      // "otp": otpCodeController.text
    };
    var bytes = utf8.encode(passwordController.text);
    var digest = md5.convert(bytes);
    print(bodyData);
    String url =
        '${CoreUrl.serviceUrl}/auth/password?identity=${searchController.text}&password=$digest}&otp${otpCodeController.text}';
    // print(url);
    Services().putRequest(bodyData, url, false, '').then((data) {
      var res = json.decode(data.body);
      print('reset passport');
      print(res);
      if (data.statusCode == 200) {
        // screenChange.value = true;
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

  timeoutCall() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSecond != 0) {
        setState(() {
          resendSecond--;
        });
      } else {
        setState(() {
          // screenChange.value == false;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              setState(() {
                Get.back();
              });
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: CoreColor().backgroundBlue,
          title: Text(
            'forget_new_tr'.translationWord(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Obx(
          () => screenChange.value == false ? screenOne() : screenTwo(),
        ));
  }

  Widget screenTwo() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          const SizedBox(height: 50),
          TextFormField(
            readOnly: true,
            autofocus: false,
            keyboardType: TextInputType.number,
            controller: searchController,
            decoration: InputDecoration(
              fillColor: Colors.grey.withOpacity(0.2),
              filled: true,
              labelText: ''.translationWord(),
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
          TextFormField(
            autofocus: false,
            keyboardType: TextInputType.number,
            controller: otpCodeController,
            decoration: InputDecoration(
              labelText: 'otp_tr'.translationWord(),
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
          TextFormField(
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'password_tr'.translationWord(),
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
          GeregeButtonWidget(
            radius: 10.0,
            elevation: 0.0,
            minWidth: GlobalVariables.gWidth,
            backgroundColor: CoreColor().backgroundYellow,
            borderColor: CoreColor().backgroundYellow,
            text: Text(
              'otp_send_tr'.translationWord(),
              style: const TextStyle(),
            ),
            onPressed: () {
              setState(() {
                // register
                if (searchController.text != "" &&
                    otpCodeController.text != "" &&
                    passwordController.text != "") {
                  resetPassword();
                } else {
                  Get.snackbar(
                    'warning_tr'.translationWord(),
                    "Талбаруудыг бөглөнө үү",
                    colorText: Colors.white,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget screenOne() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.0),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  indicatorColor: CoreColor().backgroundButton,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  controller: tabController,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontFamily: "MRegular",
                  ),
                  tabs: [
                    Tab(
                      text: 'email_tr'.translationWord(),
                    ),
                    Tab(
                      text: 'phone_num_tr'.translationWord(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            selectedIndex == 0
                ? TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    controller: searchController,
                    validator: (String? val) =>
                        GlobalValidator().emailValid(val),
                    decoration: InputDecoration(
                      labelText: 'email_tr'.translationWord(),
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
                  )
                : Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: Colors.black.withOpacity(0.2), width: 1),
                        ),
                        width: 90,
                        child: const Text(
                          '+976',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          validator: (String? val) =>
                              GlobalValidator().phoneValid(val),
                          decoration: InputDecoration(
                            counterText: '',
                            labelText: 'phone_num_tr'.translationWord(),
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
                      ),
                    ],
                  ),
            const SizedBox(height: 30),
            GeregeButtonWidget(
              radius: 10.0,
              elevation: 0.0,
              minWidth: GlobalVariables.gWidth,
              backgroundColor: CoreColor().backgroundYellow,
              borderColor: CoreColor().backgroundYellow,
              text: Text(
                'otp_send_tr'.translationWord(),
                style: const TextStyle(),
              ),
              onPressed: () {
                setState(() {
                  if (formKey.currentState!.validate()) {
                    otpSend();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
