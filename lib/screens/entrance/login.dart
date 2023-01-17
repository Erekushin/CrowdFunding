import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

import '../../../global_players.dart';
import '../../../helpers/gvariables.dart';
import '../../../style/color.dart';
import '../../controller/entrance.dart';
import '../../helpers/backHelper.dart';
import '../../widget/fundamental/btn.dart';
import '../../widget/fundamental/txt_field.dart';
import '../dialogs/question_dialogs.dart';
import 'register_recover.dart';

/// [LoginScreen] login user screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final crowdlog = logger(_LoginScreenState);
  bool? _canCheckBiometrics;
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType>? _availableBiometrics;
  BioSupportState bioSupportState = BioSupportState.unknown;
  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      crowdlog.e(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
    if (_canCheckBiometrics ?? false) {
      _getAvailableBiometrics();
    }
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      crowdlog.e(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
    if (_availableBiometrics!.isNotEmpty) {
      if (_availableBiometrics!.contains(BiometricType.strong) ||
          _availableBiometrics!.contains(BiometricType.fingerprint)) {
        try {
          final bool didAuthenticate = await auth.authenticate(
              localizedReason: 'Please authenticate to show account balance');

          if (didAuthenticate) {
            _loginController.passwordTextController.text = GlobalVariables.pass;
            _loginController.searchText.text = GlobalVariables.name;
            _loginController.loginUser();
          }
        } on PlatformException catch (e) {
          crowdlog.e(e.code);
          Get.snackbar(
            '',
            e.toString(),
            colorText: Colors.black,
            backgroundColor: Colors.white,
          );
        }
      }
    }
  }

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
    if (GlobalVariables.gStorage.read('localeShort') == null) {
      GlobalVariables.localeLong = 'mn_MN';
      GlobalVariables.gStorage.write("localeLong", GlobalVariables.localeLong);
    } else {
      GlobalVariables.localeLong = GlobalVariables.gStorage.read("localeLong");
    }
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => bioSupportState = isSupported
              ? BioSupportState.supported
              : BioSupportState.unsupported),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const SizedBox(height: 80),
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 90),
              child: Text(
                "CrowdfundingMN",
                style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                    color: CoreColor.mainPurple,
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
                margin: const EdgeInsets.only(
                    left: 35, right: 35, top: 50, bottom: 15),
                child: txtField2(_loginController.searchText,
                    'login_name_tr'.translationWord())),
            const SizedBox(height: 20),
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
            Container(
              width: GlobalVariables.gWidth * .5,
              child: generalBtn(CoreColor.mainPurple, Colors.white,
                  'login_tr'.translationWord(), () {
                if (_loginController.searchText.text != "" &&
                    _loginController.passwordTextController.text != '') {
                  _loginController.loginUser();
                } else {
                  Get.snackbar(
                    'warning_tr'.translationWord(),
                    'field_tr'.translationWord(),
                    colorText: Colors.black,
                    backgroundColor: Colors.white,
                  );
                }
              }),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Хурууны хээн нэвтрэлт',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                    //finger print tap
                    //nogoo file maani bgaa esehiig shalgah

                    onTap: () async {
                      if (GlobalVariables.pass != '') {
                        _checkBiometrics();
                      } else {
                        fingerActivation(context);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 35),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: const EdgeInsets.only(left: 0),
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
            ),
            const Spacer(),
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
    );
  }
}
