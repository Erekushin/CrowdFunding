import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/screens/login/main_login/login_screen.dart';
import 'package:get/get.dart';
// import 'dart:math' as math;
// import 'package:crowdfund_app/style/color.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/gvariables.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // var contr;
  // var storage = GetStorage();
  // AnimationController? controller;
  // Animation<double>? animation;

  // late final AnimationController _controller = AnimationController(
  //   duration: const Duration(seconds: 3),
  //   vsync: this,
  // )..repeat();
  late Timer timer;
  final RxInt _start = 1.obs;
  var storage = GetStorage();

  @override
  void initState() {
    super.initState();
    initDesktop();
    const oneSec = Duration(milliseconds: 2000);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start.value == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start.value--;
            Get.to(() => const LoginScreen());
          });
        }
      },
    );
  }

  static initDesktop() async {
    print("kIsWeb: $kIsWeb");
    // print("windows: ${Platform.isWindows}");
    // print("linux: ${Platform.isLinux}");
    // print("mac: ${Platform.isMacOS}");

    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      // await DesktopWindow.setMinWindowSize(const Size(750, 400));
      print('desktop');
    } else {
      print('elso');
    }
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

// final animation = Tween(begin: 0, end: 2 = math.pi).animate(_controller);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 171, 68),
              Color.fromRGBO(0, 147, 58, 1),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.mirror,
          ),
        ),
        child:
            // Stack(
            //   children: [
            Container(
          // duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(top: 307),
          // top: 307,
          width: GlobalVariables.gWidth,
          height: GlobalVariables.gHeight,
          // left: _start.value == 0
          //     ? ((GlobalVariables.gWidth / 3) - 35)
          //     : ((GlobalVariables.gWidth / 2) - 35),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CrowdfundingMN",
                  style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                    ),
                  ),
                ),
              ]
              // animation: _controller,
              // child: Row(
              //   children: [
              //     Center(
              //       child: Image.asset(
              //         'assets/images/solo_logo.png',
              //       ),
              //     ),
              //   ],
              // ),
              ),
          //   ),
          // ],
        ),
      ),
    );
  }
}
