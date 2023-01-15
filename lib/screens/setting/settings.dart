import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/entrance.dart';
import '../../global_players.dart';
import '../../helpers/gvariables.dart';
import '../../style/color.dart';
import '../../widget/appbar_squeare.dart';
import '../../widget/switcher.dart';
import '../dialogs/registration_dialogs.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var auth = Get.find<EntranceCont>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarSquare(
        height: GlobalVariables.gHeight * .12,
        leadingIcon: const SizedBox(),
        menuAction: () {
          Get.back();
        },
        titleColor: Colors.white,
        color: CoreColor.mainPurple,
        title: 'Тохиргоо',
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              settingUnit('Хурууны хээн нэвтрэлт', '', Colors.green, () {
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
              }, true, GlobalVariables.ifFingering),
              settingUnit(
                  'Нууц үг солих', '', Colors.green, () {}, false, false),
              settingUnit('Гүйлгээний нууц үг солих', '', Colors.green, () {},
                  false, false),
              settingUnit(GlobalVariables.email.value, '', Colors.green, () {},
                  false, false),
              GlobalVariables.phoneNumber == ''
                  ? settingUnit('Утасны дугаар оруулах', '', Colors.green, () {
                      phoneDialogy(context);
                    }, false, false)
                  : settingUnit(GlobalVariables.phoneNumber, '', Colors.green,
                      () {}, false, false),
              GlobalVariables.regNo == ''
                  ? settingUnit('Регистрийн дугаар оруулах',
                      'баталгаажаагүй байна', Colors.red, () {
                      auth.getCountryList(context);
                    }, false, false)
                  : settingUnit(GlobalVariables.regNo, '', Colors.green, () {},
                      false, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingUnit(String title, String discription, Color discriptionColor,
      Function func, bool isSwitcher, bool isSwitcherActivated) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (!isSwitcher) {
                func();
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black45, width: 0.5))),
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
            ),
          ),
          const SizedBox(height: 20),
          Text(
            discription,
            style: TextStyle(color: discriptionColor),
          )
        ],
      ),
    );
  }
}
