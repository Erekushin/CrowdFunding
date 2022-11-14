import 'package:flutter/material.dart';
import 'package:gerege_app_v2/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
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

  void localLogWriter(String text, {bool isError = false}) {
    print("aldaanii medeelel local log writer");
    print(text);
    print(isError);
  }
}
