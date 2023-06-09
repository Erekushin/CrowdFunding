import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CrowdFund/style/color.dart';
import 'package:get/get.dart';

import '../../controller/entrance.dart';
import '../../global_players.dart';
import '../../helpers/backHelper.dart';
import '../../helpers/gvariables.dart';
import '../../widget/fundamental/btn.dart';
import '../../widget/combos/sidebar.dart';
import '../entrance/login.dart';
import '../funding/projects.dart';

class LandingHome extends StatefulWidget {
  const LandingHome({super.key});

  @override
  State<LandingHome> createState() => _LandingHomeState();
}

class _LandingHomeState extends State<LandingHome> {
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xff8921aa), Color(0xffDA44bb)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final crowdlog = logger(LandingHome);
  static final EntranceCont _loginController = Get.put(EntranceCont());
  Future<bool> cloaseTheApp(BuildContext context) async {
    return await Get.defaultDialog(
        title: 'Crowdfund app ыг хаахуу?',
        content: Image.asset('assets/images/ger.png'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text(
                "exit",
                style: TextStyle(fontSize: 20),
              )),
        ]);
  }

  GlobalKey<ScaffoldState> menuSidebarKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return cloaseTheApp(context);
        },
        child: Scaffold(
          key: menuSidebarKey,
          endDrawer: Sidebar(
            menuAction: () {
              menuSidebarKey.currentState?.closeEndDrawer();
            },
          ),
          body: SizedBox(
            height: GlobalVariables.gHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                //TODO hel solih yum tavih
                SizedBox(
                    width: 400,
                    child: Image.asset('assets/images/success.png')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Become Project Creator',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      FontAwesomeIcons.circleChevronRight,
                      color: Colors.grey,
                    )
                  ],
                ),
                SizedBox(
                  width: GlobalVariables.gWidth * .8,
                  child: RichText(
                    text: TextSpan(
                        children: [
                          const TextSpan(
                              text: 'We ',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: 'Transform ',
                              style: TextStyle(
                                  foreground: Paint()
                                    ..shader = linearGradient)),
                          const TextSpan(
                              text: 'Your Ideas into Reality',
                              style: TextStyle(color: Colors.black))
                        ],
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                SizedBox(
                  width: GlobalVariables.gWidth * .5,
                  child: generalBtn(
                      CoreColor.mainPurple, Colors.white, 'Dive Into',
                      () async {
                    if (GlobalVariables.pass == '') {
                      Get.to(() => const Projects());
                    } else {
                      bool available = await GlobalPlayers.workingBioMatrix
                          .checkBiometrics(mounted);
                      if (available) {
                        _loginController.passwordTextController.text =
                            GlobalVariables.pass;
                        _loginController.searchText.text = GlobalVariables.name;
                        _loginController.loginUser();
                      }
                    }
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 2,
                                offset: const Offset(1, 1),
                              )
                            ]),
                        margin: const EdgeInsets.all(5),
                        child: const Icon(
                          FontAwesomeIcons.chevronDown,
                          size: 15,
                        )),
                    const Text('Discover more'),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
