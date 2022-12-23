import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/screens/login/main_login/login_screen.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';
// import 'dart:math' as math;
// import 'package:crowdfund_app/style/color.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'global_players.dart';
import 'helpers/gvariables.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _fontSize = 2;
  double _textOpacity = 0.0;
  double _containerSize = 1.5;
  double _containerOpacity = 0.0;
  late AnimationController _controller;
  late Animation<double> animation1;
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
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation1 = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _containerSize = 2;
        _containerOpacity = 1;
      });
    });
    Timer(const Duration(seconds: 4), () async {
      await GlobalPlayers.workingWithFile.readAll();
      Get.to(() => const LoginScreen());
    });
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
      backgroundColor: CoreColor().backgroundGreen,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.fastLinearToSlowEaseIn,
            height: GlobalVariables.gHeight / _fontSize,
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 1000),
            opacity: _textOpacity,
            child: Center(
              child: Text(
                'CrowdFundingMN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: animation1.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
