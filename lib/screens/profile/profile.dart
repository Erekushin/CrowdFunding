import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/profile/paymentDetail.dart';
import 'package:gerege_app_v2/screens/profile/security.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global_players.dart';
import '../../helpers/backHelper.dart';
import '../../widget/combos/appbar_squeare.dart';
import '../../widget/combos/sidebar.dart';
import '../../widget/fundamental/btn.dart';
import '../../widget/fundamental/txt_field.dart';
import '../home/landing_home.dart';
import 'fundedProjects.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final crowdlog = logger(Profile);

  @override
  void initState() {
    super.initState();
  }

  double optionBtnsHeight = 0;
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController rd = TextEditingController();
  GlobalKey<ScaffoldState> menuSidebarKeyPro = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return profileTop(
        menuSidebarKeyPro,
        optionBtnsHeight,
        0,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Account Detail',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Basic info',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CoreColor.mainPurple)),
            const SizedBox(
              height: 20,
            ),
            titledTextField(firstname, 'First name', GlobalVariables.firstName,
                FontAwesomeIcons.pen, () {}),
            titledTextField(lastname, 'Last name', GlobalVariables.lastName,
                FontAwesomeIcons.pen, () {}),
            titledTextField(email, 'Email', GlobalVariables.email,
                FontAwesomeIcons.pen, () {}),
            titledTextField(phone, 'Phone number', GlobalVariables.phoneNumber,
                FontAwesomeIcons.pen, () {}),
            titledTextField(rd, 'Citizen Info', GlobalVariables.regNo,
                FontAwesomeIcons.pen, () {}),
            Row(
              children: [
                generalBtn(
                    CoreColor.backlightGrey, Colors.black, 'Cancel', () {}),
                generalBtn(
                    CoreColor.mainPurple, Colors.white, 'Save Changes', () {})
              ],
            )
          ],
        ), () {
      setState(() {
        optionBtnsHeight == 0 ? optionBtnsHeight = 450 : optionBtnsHeight = 0;
      });
    });
  }
}

List optionBtns = [
  {
    'icon': FontAwesomeIcons.gear,
    'name': 'AccountDetail',
    'func': (int i) {
      Get.off(() => const Profile(), arguments: i);
    }
  },
  {
    'icon': FontAwesomeIcons.lock,
    'name': 'Security',
    'func': (int i) {
      Get.off(() => const Security(), arguments: i);
    }
  },
  {
    'icon': FontAwesomeIcons.bell,
    'name': 'Notifications',
    'func': (int i) {
      Get.off(() => const Security(), arguments: i);
    }
  },
  {
    'icon': FontAwesomeIcons.bookmark,
    'name': 'SavedItems',
    'func': (int i) {
      Get.off(() => const Profile(), arguments: i);
    }
  },
  {
    'icon': FontAwesomeIcons.rectangleList,
    'name': 'Funded Projects',
    'func': (int i) {
      Get.off(() => const FundedProjects(), arguments: i);
    }
  },
  {
    'icon': FontAwesomeIcons.creditCard,
    'name': 'Payment Details',
    'func': (int i) {
      Get.off(() => const PaymentDetail(), arguments: i);
    }
  },
  {
    'icon': FontAwesomeIcons.rightFromBracket,
    'name': 'Sign Out',
    'func': (int i) {
      Get.off(() => const LandingHome(), arguments: i);
    }
  },
];

Widget profileTop(
    GlobalKey<ScaffoldState> menuSidebarKey,
    double optionBtnsHeight,
    int comingIndex,
    Widget profileBody,
    Function func) {
  return Scaffold(
      key: menuSidebarKey,
      endDrawer: Sidebar(
        menuAction: () {
          menuSidebarKey.currentState?.closeEndDrawer();
        },
      ),
      appBar: AppbarSquare(
        height: GlobalVariables.gHeight * .12,
        leadingIcon: Icon(
          FontAwesomeIcons.bars,
          color: Colors.black,
          size: Sizes.iconSize,
        ),
        menuAction: () {
          menuSidebarKey.currentState!.openEndDrawer();
        },
        titleColor: Colors.black,
        color: Colors.white,
        title: 'Crowd',
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 50, bottom: 50, left: 20, right: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: 105,
            height: 105,
            child: Stack(
              //profile pic
              children: [
                CircleAvatar(
                    backgroundColor: CoreColor.backlightGrey,
                    backgroundImage: const NetworkImage(
                        'https://i.pinimg.com/564x/66/1e/3c/661e3c81c896137ea8b88f54dfebf55c.jpg'),
                    radius: 50),
                Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.3),
                                blurRadius: 5,
                                offset: const Offset(1, 1),
                              )
                            ]),
                        margin: const EdgeInsets.all(5),
                        child: const Icon(
                          FontAwesomeIcons.rotateLeft,
                          size: 15,
                        )))
              ],
            ),
          ),
          const SizedBox(height: 10),
          Column(
            //ner bolon email
            children: [
              Text(
                GlobalVariables.firstName,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                GlobalVariables.email,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              func();
            },
            child: Container(
              //account options
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 237, 236, 238),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.user,
                    size: 15,
                  ),
                  SizedBox(width: 10),
                  Text('Account menu'),
                  SizedBox(width: 10),
                  Icon(
                    FontAwesomeIcons.chevronDown,
                    size: 15,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: optionBtnsHeight,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: optionBtns.length,
                itemBuilder: (c, i) {
                  return InkWell(
                    highlightColor: Colors.white,
                    radius: 180,
                    splashColor: const Color.fromARGB(255, 156, 109, 243),
                    onTap: () {
                      optionBtns[i]['func'](i);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: comingIndex == i
                          ? const BoxDecoration(
                              color: Color.fromARGB(255, 156, 109, 243),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 156, 109, 243),
                                    blurRadius: 20,
                                    offset: Offset(1, 5),
                                  )
                                ])
                          : const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(
                            optionBtns[i]['icon'],
                            size: 15,
                            color:
                                comingIndex == i ? Colors.white : Colors.black,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            optionBtns[i]['name'],
                            style: TextStyle(
                                color: comingIndex == i
                                    ? Colors.white
                                    : Colors.black),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
          profileBody,
        ]),
      ));
}
