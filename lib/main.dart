import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/platforms/desktop_helper.dart';
import 'package:gerege_app_v2/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  /// false -> phone true-> tablet
  GlobalVariables.useTablet = DesktopHelper().getDeviceType();
  print("GlobalVariables.useTablet ");
  print(GlobalVariables.useTablet);
  runApp(const Main());
}

/// [GetMaterialApp] use getx state management
class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      logWriterCallback: localLogWriter,
      theme: ThemeData(),
      darkTheme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino, //Transition.rightToLeft,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }

  void localLogWriter(String text, {bool isError = false}) {}
}
