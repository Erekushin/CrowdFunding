import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:get_storage/get_storage.dart';

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

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();
  late Timer timer;
  final RxInt _start = 1.obs;
  var storage = GetStorage();

  @override
  void initState() {
    super.initState();
    print('sdawe');
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
            // Get.to(() => const LoginScreen());
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
      print('wetdsadas');
    } else {
      print('elso');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
              Color.fromRGBO(67, 119, 222, 1),
              Color.fromRGBO(0, 58, 172, 1),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Stack(
          children: [
            Obx(() => AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  top: 250,
                  left: _start.value == 0
                      ? ((GlobalVariables.gWidth / 2) - 35)
                      : ((GlobalVariables.gWidth / 2) - 35),
                  child: AnimatedBuilder(
                    animation: _controller,
                    child: Row(
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/solo_logo.png',
                          ),
                        ),
                        _start.value == 0
                            ? const SizedBox(width: 15)
                            : Container(),
                        _start.value == 0
                            ? AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 500),
                                child: Image.asset(
                                  'assets/images/gerege_title.png',
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    builder: (BuildContext context, Widget? child) {
                      return Transform.rotate(
                        angle: _start.value == 0
                            ? _controller.value * 0 * math.pi
                            : _controller.value * 1.0 * math.pi,
                        child: child,
                      );
                    },
                  ),
                )),
            Positioned(
              bottom: 0,
              right: 180,
              child: Image.asset(
                "assets/images/emblem.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
