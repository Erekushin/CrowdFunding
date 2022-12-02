import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/home/me/confirmation_screen.dart';
import 'package:gerege_app_v2/screens/home/me/core_info_user.dart';
import 'package:gerege_app_v2/screens/home/me/login_info_screen.dart';
import 'package:gerege_app_v2/screens/home/app_service/service_screen.dart';
import 'package:gerege_app_v2/screens/login/phone/login_screen.dart';
import 'package:gerege_app_v2/screens/login/tablet/login_screen_tablet.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
import 'package:gerege_app_v2/widget/sidebar/header_logo.dart';
import 'package:gerege_app_v2/widget/sidebar/menu.dart';
import 'package:get/route_manager.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GlobalVariables.gHeight,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: Drawer(
          elevation: 1.0,
          child: Column(
            children: <Widget>[
              const HeaderLogoWidget(),
              const Expanded(child: MenuWidget()),
              GeregeButtonWidget(
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
