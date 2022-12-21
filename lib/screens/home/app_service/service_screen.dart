import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/main_tab.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';

import '../../content_home/home.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List serviceData = [
    {"id": 0, "img": "achilt.png", "name": "Шалгах"},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: CoreColor().backgroundBlue,
          title: const Text('Үйлчилгээ'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              // Get.back();
              // Get.offAll(() => const MainTab(indexTab: 0));
              Get.to(() => const ContentHome());
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
        ),
        body: GridView.count(
          crossAxisCount: GlobalVariables.useTablet ? 4 : 3,
          childAspectRatio: (0.4 / .4),
          shrinkWrap: true,
          children: List.generate(serviceData.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: Image.asset(
                          "assets/icons/${serviceData[index]['img']}",
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        '${serviceData[index]['name']}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ));
  }
}
