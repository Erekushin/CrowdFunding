import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CrowdFund/helpers/working_string.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

import '../../../global_players.dart';
import '../../../helpers/gvariables.dart';
import '../../../style/color.dart';
import '../../controller/entrance.dart';
import '../../dialogs/snacks.dart';
import '../../helpers/backHelper.dart';
import '../../helpers/frontHelper.dart';
import '../../widget/fundamental/btn.dart';
import '../../widget/fundamental/txt_field.dart';
import '../../dialogs/question_dialogs.dart';
import 'register_recover.dart';

/// [LoginScreen] login user screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final crowdlog = logger(_LoginScreenState);

  bool hidePassword = true;
  static final EntranceCont _loginController = Get.put(EntranceCont());
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
    GlobalVariables.localeLong = 'mn_MN';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('fdfdfdff');
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: ScrollConfiguration(
          behavior: MyscrollBehavior(),
          child: SingleChildScrollView(
            child: SizedBox(
              height: GlobalVariables.gHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 100),
                    child: Text(
                      "Crowdfunding",
                      style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                          color: CoreColor.mainPurple,
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 35, right: 35, top: 50, bottom: 0),
                      child: txtField2(_loginController.searchText,
                          'login_name_tr'.translationWord())),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 35,
                      right: 35,
                      bottom: 15,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                            width: GlobalVariables.gWidth * .8,
                            child: TxtFieldPass(
                              txtCont: _loginController.passwordTextController,
                              hinttxt: 'password_tr'.translationWord(),
                            )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => const Register_Recover(
                                title: 'Нууц үг сэргээх',
                              ));
                        },
                        child: Text(
                          'Мартсан?',
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                              color: CoreColor.mainPurple,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 50)
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: GlobalVariables.gWidth * .5,
                    child: generalBtn(CoreColor.mainPurple, Colors.white,
                        'login_tr'.translationWord(), () {
                      if (_loginController.searchText.text != "" &&
                          _loginController.passwordTextController.text != '') {
                        _loginController.loginUser();
                      } else {
                        warningSnack('field_tr');
                      }
                    }),
                  ),
                  const SizedBox(height: 10),
                  GlobalPlayers.workingBioMatrix.biomatrixSupported
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Хурууны хээн нэвтрэлт',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                                onTap: () async {
                                  if (GlobalVariables.pass == '') {
                                    fingerActivation(context);
                                  } else {
                                    bool available = false;
                                    available = await GlobalPlayers
                                        .workingBioMatrix
                                        .checkBiometrics(mounted);
                                    if (available == true) {
                                      _loginController.passwordTextController
                                          .text = GlobalVariables.pass;
                                      _loginController.searchText.text =
                                          GlobalVariables.name;
                                      _loginController.loginUser();
                                    }
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 35),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 0),
                                          blurStyle: BlurStyle.outer,
                                        )
                                      ]),
                                  width: 50,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaY: 5, sigmaX: 5),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 0),
                                          child: const Icon(
                                            FontAwesomeIcons.fingerprint,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        )
                      : const SizedBox(),
                  const Spacer(),
                  SizedBox(
                      width: GlobalVariables.gWidth * .5,
                      child: iconedBtn(Colors.redAccent, Colors.white, 'Google',
                          FontAwesomeIcons.google, () {})),
                  SizedBox(
                      width: GlobalVariables.gWidth * .5,
                      child: iconedBtn(Colors.blue, Colors.white, 'Facebook',
                          FontAwesomeIcons.facebook, () {})),
                  Container(
                    margin: const EdgeInsets.only(left: 50, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(() => const Register_Recover(
                                  title: 'Бүртгүүлэх',
                                ));
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
                                style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                    color: CoreColor.mainPurple,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
