import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/controller/profileCont.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/profile/security.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global_players.dart';
import '../../helpers/backHelper.dart';
import '../../widget/appbar_squeare.dart';
import '../../widget/txt_field.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final crowdlog = logger(Profile);
  var proCont = Get.put(ProfileCont());

  @override
  void initState() {
    super.initState();
  }

  double optionBtnsHeight = 0;
  @override
  Widget build(BuildContext context) {
    return profileTop(
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
            titledTextField(),
            titledTextField(),
            titledTextField(),
            titledTextField(),
          ],
        ), () {
      setState(() {
        optionBtnsHeight == 0 ? optionBtnsHeight = 420 : optionBtnsHeight = 0;
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
    'name': 'Securityl',
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
    'name': 'My Collections',
    'func': (int i) {
      Get.off(() => const Profile(), arguments: i);
    }
  },
  {
    'icon': FontAwesomeIcons.creditCard,
    'name': 'Payment Details',
    'func': (int i) {
      Get.off(() => const Profile(), arguments: i);
    }
  },
  {
    'icon': FontAwesomeIcons.rightFromBracket,
    'name': 'Sign Out',
    'func': (int i) {
      Get.off(() => const Security(), arguments: i);
    }
  },
];

//each btn is 60 for height
Widget profileTop(
    double height, int comingIndex, Widget profileBody, Function func) {
  var proCont = Get.put(ProfileCont());
  return Scaffold(
      appBar: AppbarSquare(
        height: GlobalVariables.gHeight * .12,
        leadingIcon: Icon(
          FontAwesomeIcons.bars,
          color: Colors.black,
          size: Sizes.iconSize,
        ),
        menuAction: () {},
        titleColor: Colors.black,
        color: Colors.white,
        title: 'Crowd',
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 50, bottom: 50, left: 20, right: 20),
        child: SizedBox(
          width: GlobalVariables.gWidth,
          height: GlobalVariables.gHeight + 500,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                  GlobalVariables.email.value,
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
            SizedBox(
              height: height,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: optionBtns.length,
                  itemBuilder: (c, i) {
                    return InkWell(
                      splashColor: Color.fromARGB(255, 156, 109, 243),
                      onTap: () {
                        optionBtns[i]['func'](i);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: comingIndex == i
                                ? Color.fromARGB(255, 156, 109, 243)
                                : Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: comingIndex == i
                                    ? Color.fromARGB(255, 156, 109, 243)
                                    : Colors.white,
                                blurRadius: 20,
                                offset: const Offset(1, 5),
                              )
                            ]),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(
                              optionBtns[i]['icon'],
                              size: 15,
                              color: comingIndex == i
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            SizedBox(
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
        ),
      ));
}
