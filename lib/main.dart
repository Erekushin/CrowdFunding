import 'package:flutter/material.dart';
import 'package:gerege_app_v2/global_players.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/platforms/desktop_helper.dart';
import 'package:gerege_app_v2/screens/home/splash_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import 'controller/entrance.dart';

void main() async {
  //erek changes
  WidgetsFlutterBinding.ensureInitialized();
  // await GetStorage.init();

  /// false -> phone true-> tablet
  GlobalVariables.useTablet = DesktopHelper().getDeviceType();
  DesktopHelper().getModelVersion();
  if (GlobalVariables.useTablet) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]).then((value) => runApp(const Main()));
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((value) => runApp(const Main()));
  }
  GlobalPlayers.workingBioMatrix.checkSupportState();
}

/// [GetMaterialApp] use getx state management
class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialBinding: BindingsBuilder(() => bindInitialControllers()),
        enableLog: true,
        logWriterCallback: localLogWriter,
        theme: ThemeData(),
        darkTheme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino, //Transition.rightToLeft,
        themeMode: ThemeMode.light,
        home: const SplashScreen());
  }

  void localLogWriter(String text, {bool isError = false}) {}
  bindInitialControllers() {
    Get.put(EntranceCont(), permanent: true);
  }
}
