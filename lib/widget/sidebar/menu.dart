import 'package:flutter/material.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';
import '../../screens/home/app_service/service_screen.dart';
import '../../screens/home/me/confirmation_screen.dart';
import '../../screens/home/me/core_info_user.dart';
import '../../screens/home/me/login_info_screen.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  // const _MenuWidgetState({
  //   Key? key,
  // });

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
