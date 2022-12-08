import 'package:flutter/material.dart';
import 'package:gerege_app_v2/controller/login_controller.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/login/create_user.dart';
import 'package:gerege_app_v2/screens/login/forget_password.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
import 'package:gerege_app_v2/widget/gerege_textfield.dart';
import 'package:get/get.dart';

import '../../../controller/content.dart';

/// [LoginScreen] login user screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;
  static final LoginController _loginController = Get.put(LoginController());
  String langName = "Мон";

  List langList = [
    {"name": "Мон", "key": "mn_MN"},
    {"name": "Eng", "key": "en_US"},
    {"name": "Рус", "key": "ru_RU"},
    {"name": "中文", "key": ""},
    {"name": "한국어", "key": ""}
  ];

  @override
  void initState() {
    if (GlobalVariables.gStorage.read('localeShort') == null) {
      GlobalVariables.localeLong = 'mn_MN';
      GlobalVariables.gStorage.write("localeLong", GlobalVariables.localeLong);
    } else {
      GlobalVariables.localeLong = GlobalVariables.gStorage.read("localeLong");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: phoneLogin(),
      ),
    );
  }

  Widget phoneLogin() {
    return Column(
      children: [
        const SizedBox(height: 80),
        Container(
          alignment: Alignment.topCenter,
          child: Image.asset(
            "assets/images/gerege_logo.png",
            width: GlobalVariables.gWidth / 3,
          ),
        ),
        const SizedBox(height: 50),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: GeregeTextField(
            controller: _loginController.searchText!,
            label: 'login_name_tr',
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: GeregeTextField(
            controller: _loginController.passwordTextController!,
            label: 'password_tr',
            obscureText: hidePassword,
            suffinIcon: IconButton(
              icon: Icon(
                hidePassword ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 30),
        GeregeButtonWidget(
          elevation: 0.0,
          minWidth: GlobalVariables.gWidth / 1.6,
          backgroundColor: CoreColor().backgroundBlue,
          text: Text(
            'login_tr'.translationWord(),
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (_loginController.searchText?.text != "" &&
                _loginController.passwordTextController?.text != '') {
              _loginController.loginUser(context, 1);
            } else {
              Get.snackbar(
                'warning_tr'.translationWord(),
                'field_tr'.translationWord(),
                colorText: Colors.black,
                backgroundColor: Colors.white,
              );
            }
          },
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Get.to(() => const CreateUserScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'create_register_tr'.translationWord(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'new_user_tr'.translationWord(),
                      style: TextStyle(
                        color: CoreColor().backgroundYellow,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const ForgetPasswordScreen());
                },
                child: Text(
                  'forget_password_tr'.translationWord(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.only(left: 50, right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var lang in langList)
                InkWell(
                  onTap: () {
                    setState(() {
                      langName = lang['name'];
                      if (lang['key'] != "") {
                        GlobalVariables.localeLong = lang['key'];
                        GlobalVariables.gStorage
                            .write("localeLong", GlobalVariables.localeLong);
                      }
                    });
                  },
                  child: Text(
                    "${lang['name']}",
                    style: TextStyle(
                      color: langName == lang['name']
                          ? CoreColor().backgroundYellow
                          : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
