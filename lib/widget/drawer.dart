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
              Container(
                decoration: BoxDecoration(
                  color: CoreColor().backgroundBlue,
                ),
                height: 200,
                width: GlobalVariables.gWidth,
                child: Stack(
                  children: [
                    SizedBox(
                      width: GlobalVariables.gWidth,
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          SizedBox(
                            height: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(
                                "assets/images/gerege_logo_white.png",
                                fit: BoxFit.cover,
                                height: GlobalVariables.gHeight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 45,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const ServiceScreen());
                        },
                        child: ListTile(
                          title: const Text(
                            'Үйлчилгээ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: CoreColor().backgroundBlue,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 45,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const CoreInfoScreen());
                        },
                        child: ListTile(
                          title: const Text(
                            'Үндсэн мэдээлэл',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: CoreColor().backgroundBlue,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 45,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const LoginInfoScreen());
                        },
                        child: ListTile(
                          title: const Text(
                            'Нэвтрэх мэдээлэл',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: CoreColor().backgroundBlue,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 45,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const ConfirmationScreen());
                        },
                        child: ListTile(
                          title: const Text(
                            'Баталгаажуулалт',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: CoreColor().backgroundBlue,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
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
