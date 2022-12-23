import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';
import '../../global_players.dart';
import '../../helpers/gvariables.dart';
import '../../style/color.dart';
import '../../widget/appbar_squeare.dart';
import '../../widget/switcher.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var auth = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarSquare(
        height: GlobalVariables.gWidth * .4,
        leadingIcon: const Icon(
          FontAwesomeIcons.chevronLeft,
          color: Colors.white,
          size: 18,
        ),
        menuAction: () {
          Get.back();
        },
        titleColor: Colors.white,
        color: CoreColor.mainGreen,
        title: 'Тохиргоо',
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              settingUnit('Хурууны хээн нэвтрэлт', () {
                if (GlobalVariables.ifFingering == false) {
                  GlobalPlayers.workingWithFile
                      .addNewItem('isFingering', 'true');
                  GlobalPlayers.workingWithFile
                      .addNewItem('name', auth.searchText!.text);
                  GlobalPlayers.workingWithFile
                      .addNewItem('pass', auth.passwordTextController!.text);
                } else if (GlobalVariables.pass != '') {
                  GlobalPlayers.workingWithFile.deleteAll();
                }
              }, true, GlobalVariables.ifFingering),
              settingUnit('Нууц үг солих', () {}, false, false),
              settingUnit('Гүйлгээний нууц үг солих', () {}, false, false)
            ],
          ),
        ),
      ),
    );
  }

  Widget settingUnit(
      String title, Function func, bool isSwitcher, bool isSwitcherActivated) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black45, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          isSwitcher
              ? MySwitcher(
                  switcherValue: isSwitcherActivated,
                  func: () {
                    func();
                  },
                )
              : const Icon(
                  FontAwesomeIcons.rightLong,
                  size: 12,
                )
        ],
      ),
    );
  }
}
