import 'package:flutter/material.dart';
import 'package:gerege_app_v2/screens/profile/profile.dart';
import 'package:get/get.dart';

import '../../controller/profileCont.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  var proCont = Get.put(ProfileCont());
  int proBtnInx = Get.arguments as int;
  var scrollController = ScrollController();
  double optionBtnsHeight = 0;
  @override
  Widget build(BuildContext context) {
    return profileTop(
        optionBtnsHeight,
        proBtnInx,
        Column(
          children: [Text('second page')],
        ), () {
      setState(() {
        optionBtnsHeight == 0 ? optionBtnsHeight = 420 : optionBtnsHeight = 0;
      });
    });
  }
}
