import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/screens/profile/profile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_file.dart';

import '../../controller/entrance.dart';
import '../../global_players.dart';
import '../../helpers/gvariables.dart';
import '../../style/color.dart';
import '../../widget/fundamental/btn.dart';
import '../../widget/fundamental/switcher.dart';
import '../../widget/fundamental/txt_field.dart';

class Security extends StatefulWidget {
  const Security({super.key});
  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  int proBtnInx = Get.arguments as int;
  var auth = Get.find<EntranceCont>();
  double optionBtnsHeight = 0;
  bool isSwitcherActivated = false;
  GlobalKey<ScaffoldState> menuSidebarKeySec = GlobalKey<ScaffoldState>();
  Color getOtp = CoreColor.mainPurple;
  Color getOtptxt = Colors.white;
  Color saveChanges = CoreColor.backlightGrey;
  Color saveChangestxt = Colors.black;

  @override
  void initState() {
    if (GlobalVariables.pass != '' &&
        GlobalPlayers.workingBioMatrix.biomatrixSupported) {
      isSwitcherActivated = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return profileTop(
        menuSidebarKeySec,
        optionBtnsHeight,
        proBtnInx,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Security',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            GlobalPlayers.workingBioMatrix.biomatrixSupported
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Finger print',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CoreColor.mainPurple)),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Biomatrix activation',
                            style: GoogleFonts.sourceSansPro(
                                height: 2,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black54),
                          ),
                          MySwitcher(
                            switcherValue: isSwitcherActivated,
                            func: () async {
                              bool available = await GlobalPlayers
                                  .workingBioMatrix
                                  .checkBiometrics(mounted);
                              if (available) {
                                if (GlobalVariables.pass == '') {
                                  GlobalPlayers.workingWithFile
                                      .addNewItem('isFingering', 'true');
                                  GlobalPlayers.workingWithFile
                                      .addNewItem('name', auth.searchText.text);
                                  GlobalPlayers.workingWithFile
                                      .addNewItem('pass', auth.passTxt.text);
                                } else if (GlobalVariables.pass != '') {
                                  GlobalPlayers.workingWithFile.deleteAll();
                                }
                              }
                              return available;
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : const SizedBox(),
            Text('Password',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CoreColor.mainPurple)),
            const SizedBox(
              height: 20,
            ),
            titledTextField(auth.registerText, 'Enter email or Phone number',
                'Email or Phone', FontAwesomeIcons.eye, () {}),
            generalBtn(getOtp, getOtptxt, 'Get OTP code', () async {
              bool success = await auth.otpSend(
                  'profile_security', 'auth/password?identity=');
              if (success) {
                setState(() {
                  getOtp = CoreColor.backlightGrey;
                  getOtptxt = Colors.black;
                  saveChanges = CoreColor.mainPurple;
                  saveChangestxt = Colors.white;
                });
              }
            }),
            titledTextField(auth.otpTxt, 'OTP code', '_ _ _ _ _ _',
                FontAwesomeIcons.eye, () {}),
            titledTextField(auth.passTxt, 'New password', '********',
                FontAwesomeIcons.pen, () {}),
            titledTextField(auth.passVerifyTxt, 'Confirm new password',
                '********', FontAwesomeIcons.pen, () {}),
            generalBtn(saveChanges, saveChangestxt, 'Save changes', () {
              auth.resetPassword();
            }),
          ],
        ), () {
      setState(() {
        optionBtnsHeight == 0 ? optionBtnsHeight = 450 : optionBtnsHeight = 0;
      });
    });
  }
}
