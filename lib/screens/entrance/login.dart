import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

import '../../../controller/login_controller.dart';
import '../../../global_players.dart';
import '../../../helpers/gvariables.dart';
import '../../../helpers/logging.dart';
import '../../../style/color.dart';
import '../../../widget/gerege_button.dart';
import '../../../widget/gerege_textfield.dart';
import '../login/forget_password.dart';
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
            _loginController.passwordTextController!.text =
                GlobalVariables.pass;
            _loginController.searchText!.text = GlobalVariables.name;
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
                    color: CoreColor().backgroundGreen,
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
              child: GeregeTextField(
                controller: _loginController.searchText!,
                label: 'login_name_tr',
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 35, right: 35, bottom: 15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    GeregeTextField(
                      controller: _loginController.passwordTextController!,
                      label: 'password_tr',
                      obscureText: hidePassword,
                    ),
                    Positioned(
                      right: 9,
                      top: 20,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const ForgetPasswordScreen());
                        },
                        child: Text(
                          'Мартсан?',
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                              color: CoreColor().backgroundGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            GeregeButtonWidget(
              elevation: 0.0,
              minWidth: GlobalVariables.gWidth / 1.2,
              backgroundColor: CoreColor().backgroundGreen,
              borderColor: CoreColor().backgroundGreen,
              text: Text(
                'login_tr'.translationWord(),
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_loginController.searchText?.text != "" &&
                    _loginController.passwordTextController?.text != '') {
                  _loginController.loginUser();
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
                        showDialog(
                            context: context,
                            builder: (context) => SimpleDialog(
                                  title: const Text(
                                      'Хурууны хээн нэвтрэлтийг идвэхжүүлхүү?'),
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (bioSupportState ==
                                            BioSupportState.unknown) {
                                          Get.snackbar('Уучлаарай',
                                              "Хурууны хээ уншигчийн төрөл таарахгүй байна!",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              colorText: Colors.white,
                                              backgroundColor: Colors.grey[900],
                                              margin: const EdgeInsets.all(5));
                                        } else if (bioSupportState ==
                                            BioSupportState.supported) {
                                          GlobalPlayers.workingWithFile
                                              .addNewItem(
                                                  'isFingering', 'true');

                                          Get.snackbar('Боломжтой',
                                              "Та эхний удаа нэр, нууц үгээ хийж нэвтэрнэ үү!",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              colorText: Colors.white,
                                              backgroundColor: Colors.grey[900],
                                              margin: const EdgeInsets.all(5));
                                        } else {
                                          Get.snackbar('Уучлаарай',
                                              "Хурууны хээ уншигчийг ачааллахад алдаа гарлаа!",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              colorText: Colors.white,
                                              backgroundColor: Colors.grey[900],
                                              margin: const EdgeInsets.all(5));
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: GlobalVariables.gWidth * .4,
                                        margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.all(10),
                                        color: Colors.grey.shade300,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('идвэхжүүлэх'),
                                            Icon(
                                              FontAwesomeIcons.check,
                                              color: Colors.amber,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                                bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                color: Colors.amber),
                                            child: Center(
                                              child: Text('хаах'),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ));
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
                      print('dfdf');
                      Get.to(() => const Register_Recover(
                            route: 'login',
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
                              color: CoreColor().backgroundGreen,
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
        // GlobalVariables.useTablet == false ? phoneLogin() : tabletLogin(),
      ),
    );
  }
}
