import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/screens/login/phone/create_user/send_otp.dart';
import 'package:gerege_app_v2/screens/login/phone/create_user/register_user.dart';
import 'package:gerege_app_v2/screens/login/phone/create_user/register_user_infor.dart';
import 'package:get/get.dart';

import '../content_home/home.dart';

/// [CreateUserScreen] create user screen

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  RxInt screenChange = 0.obs;

  int resendSecond = 60;
  int selectedIndex = 0;
  RxList countryList = [].obs;

  @override
  void initState() {
    super.initState();
  }

  getCountryList() {
    String url = '${CoreUrl.crowdfund}countries?page_size=500&page_number=1';
    Services().getRequest(url, true, '').then((data) {
      if (data.statusCode == 200) {
        setState(() {
          countryList.value = data.body['result']['items'];
          screenChange.value = 2;
        });
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: Colors.red.withOpacity(0.2),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              Get.back();
            });
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: CoreColor().backgroundBlue,
        title: Text(
          'new_user_tr'.translationWord(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => screenChange.value == 0
              ? SendOtp(onPressed: ((val) {
                  setState(() {
                    screenChange.value = val;
                  });
                }))
              : screenChange.value == 1
                  ? Registeruser(
                      click: ((val) {
                        getCountryList();
                      }),
                    )
                  : RegisterUserInfor(
                      countryList: countryList,
                      onPressed: (val) {
                        // Get.to(() => const MainTab(indexTab: 0));
                        Get.to(() => const ContentHome());
                      },
                    ),
        ),
      ),
    );
  }
}
