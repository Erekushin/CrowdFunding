import 'package:flutter/material.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/sidebar/header_logo.dart';
import 'package:gerege_app_v2/widget/sidebar/menu.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../helpers/gvariables.dart';
import '../screens/login/phone/login_screen.dart';
import '../screens/login/tablet/login_screen_tablet.dart';
import 'gerege_button.dart';

class DrawerTabletWidget extends StatefulWidget {
  const DrawerTabletWidget({Key? key}) : super(key: key);

  @override
  State<DrawerTabletWidget> createState() => _DrawerTabletWidgetState();
}

class _DrawerTabletWidgetState extends State<DrawerTabletWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: GlobalVariables.gHeight,
        width: GlobalVariables.useTablet ? 250 : 0,
        child: Container(
          color: Colors.white,
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const HeaderLogoWidget(),
              // const Expanded(
              //   child: SizedBox(
              //       height: 45,
              //       child: InkWell(
              //         child: Text("{da"),
              //       )),
              // ),
              const Expanded(
                child: MenuWidget(),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: GeregeButtonWidget(
                  radius: 10.0,
                  elevation: 0.0,
                  height: 40,
                  minWidth: GlobalVariables.gWidth / 1.6,
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.black,
                  text: const Text(
                    'Гарах',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      GlobalVariables.gStorage.erase();
                      if (GlobalVariables.useTablet) {
                        Get.offAll(() => const LoginScreenTablet());
                      } else {
                        Get.offAll(() => const LoginScreen());
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
