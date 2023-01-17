import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/screens/profile/profile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
  TextEditingController a = TextEditingController();
  double optionBtnsHeight = 0;
  bool isSwitcherActivated = GlobalVariables.ifFingering;
  GlobalKey<ScaffoldState> menuSidebarKeySec = GlobalKey<ScaffoldState>();
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
                  func: () {
                    if (GlobalVariables.ifFingering == false) {
                      GlobalPlayers.workingWithFile
                          .addNewItem('isFingering', 'true');
                      GlobalPlayers.workingWithFile
                          .addNewItem('name', auth.searchText.text);
                      GlobalPlayers.workingWithFile
                          .addNewItem('pass', auth.passwordTextController.text);
                    } else if (GlobalVariables.pass != '') {
                      GlobalPlayers.workingWithFile.deleteAll();
                    }
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Password',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CoreColor.mainPurple)),
            const SizedBox(
              height: 20,
            ),
            titledTextField(a, 'Enter email or Phone number', 'Email or Phone',
                FontAwesomeIcons.eye, () {}),
            generalBtn(
                CoreColor.mainPurple, Colors.white, 'Get OTP code', () {}),
            titledTextField(
                a, 'OTP code', '_ _ _ _ _ _', FontAwesomeIcons.eye, () {}),
            generalBtn(
                CoreColor.backlightGrey, Colors.black, 'Test OTP code', () {}),
            titledTextField(
                a, 'New password', '********', FontAwesomeIcons.pen, () {}),
            titledTextField(a, 'Confirm new password', '********',
                FontAwesomeIcons.pen, () {}),
            generalBtn(
                CoreColor.backlightGrey, Colors.black, 'Save changes', () {}),
          ],
        ), () {
      setState(() {
        optionBtnsHeight == 0 ? optionBtnsHeight = 450 : optionBtnsHeight = 0;
      });
    });
  }
}
