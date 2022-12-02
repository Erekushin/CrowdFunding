import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/main_tab.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List serviceData = [
    {"id": 0, "img": "achilt.png", "name": "Шалгах"},
    {"id": 1, "img": "garah2.png", "name": "Орсон"},
    {"id": 2, "img": "garaltiinPuu.png", "name": "Зогсоол"},
    {"id": 3, "img": "huchilt1.png", "name": "Анхны пүү"},
    {"id": 4, "img": "oroltiinPuu.png", "name": "Ачих"},
    {"id": 5, "img": "oruulah.png", "name": "Тохируулгын пүү"},
    {"id": 6, "img": "shalgalt1.png", "name": "Хучилт"},
    {"id": 7, "img": "tohiruulga1.png", "name": "Гаралтын пүү"},
    {"id": 8, "img": "zogsool2.png", "name": "Гарсан"},
    // 1    Шалгах
    // 2    Орсон
    // 3    Зогсоол
    // 4    Анхны пүү
    // 5    Ачих
    // 6    Тохируулгын пүү
    // 7    Хучилт
    // 8    Гаралтын пүү
    // 9    Гарсан
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
              Get.offAll(() => const MainTab(indexTab: 0));
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
