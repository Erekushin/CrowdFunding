import 'dart:convert';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/screens/home/me/document_screen.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:get/route_manager.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({Key? key}) : super(key: key);

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  List menu = [
    {"id": 0, "title": "Үндсэн мэдээлэл"},
    {"id": 1, "title": "Баталгаажуулалт"},
    {"id": 2, "title": "Нэвтрэх мэдээлэл"},
    {"id": 3, "title": "Бичиг баримт"},
  ];
  var passHeigth = GlobalVariables.gWidth / 1.5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Stack(
                children: [
                  GlobalVariables.isForeign == 0
                      ? Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          // bottom: 20, top: 20
                          width: GlobalVariables.gWidth,
                          height: passHeigth,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                  "assets/images/irgenii_unemleh.png"),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: GlobalVariables.gHeight / 13,
                                left: 10,
                                child: InkWell(
                                  onTap: () {
                                    // _showPickerProfile(context);
                                  },
                                  child: GlobalVariables.profileImage.value !=
                                          ''
                                      ? SizedBox(
                                          height: 120,
                                          width: 80,
                                          child: Image.memory(
                                            const Base64Decoder().convert(
                                              GlobalVariables.profileImage.value
                                                  .replaceAll(
                                                      'data:image/jpeg;base64,',
                                                      ''),
                                            ),
                                            fit: BoxFit.cover,
                                            cacheWidth: 80,
                                            cacheHeight: 120,
                                          ),
                                        )
                                      : Container(
                                          height: 100,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: CoreColor().backgroundBlue,
                                            ),
                                          ),
                                          child: const Text(""),
                                        ),
                                ),
                              ),
                              Positioned(
                                top: passHeigth / 4,
                                left: passHeigth / 2.5,
                                child: Text(
                                  GlobalVariables.familyName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: passHeigth / 2.5,
                                left: passHeigth / 2.5,
                                child: Text(
                                  GlobalVariables.lastName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: passHeigth / 4,
                                right: passHeigth / 2.6,
                                child: Text(
                                  GlobalVariables.gender == 0 ? "F" : "M",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: passHeigth / 1.9,
                                left: passHeigth / 2.5,
                                child: Text(
                                  GlobalVariables.firstName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: passHeigth / 1.5,
                                left: passHeigth / 2.5,
                                child: Text(
                                  GlobalVariables.regNo,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: passHeigth / 2.3,
                                right: passHeigth / 7,
                                child: Text(
                                  GlobalVariables.birthDate,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        GlobalVariables.civilId,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 5, left: 10),
                                      child: BarcodeWidget(
                                        barcode: Barcode.code128(),
                                        data: GlobalVariables.civilId,
                                        drawText: false,
                                        height: 50,
                                        width: 180,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Positioned(
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20, top: 20),
                            width: GlobalVariables.gWidth,
                            height: passHeigth,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image:
                                    AssetImage("assets/images/bg_foreign.png"),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: GlobalVariables.gHeight / 13,
                                  left: 20,
                                  child: InkWell(
                                    onTap: () {
                                      print("upload112");
                                      // _showPickerProfile(context);
                                    },
                                    child: GlobalVariables.profileImage.value !=
                                            ''
                                        ? SizedBox(
                                            height: 120,
                                            width: 95,
                                            child: Image.memory(
                                              const Base64Decoder().convert(
                                                  GlobalVariables
                                                      .profileImage.value
                                                      .replaceAll(
                                                          'data:image/jpeg;base64,',
                                                          '')),
                                              fit: BoxFit.cover,
                                              cacheHeight: 120,
                                              cacheWidth: 95,
                                            ),
                                          )
                                        : Container(
                                            height: 120,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: Colors.green,
                                              ),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '+',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ),
                                            // child: Container(
                                            // ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  top: passHeigth / 4,
                                  left: passHeigth / 1.8,
                                  child: Text(
                                    GlobalVariables.isForeign == 0
                                        ? "MNG"
                                        : GlobalVariables.countryName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: passHeigth / 2.5,
                                  left: passHeigth / 1.8,
                                  child: Text(
                                    GlobalVariables.lastName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: passHeigth / 2.5,
                                  right: passHeigth / 6,
                                  child: Text(
                                    GlobalVariables.gender == 0 ? "F" : "M",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: passHeigth / 1.8,
                                  left: passHeigth / 1.8,
                                  child: Text(
                                    GlobalVariables.firstName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: passHeigth / 1.46,
                                  left: passHeigth / 1.8,
                                  child: Text(
                                    GlobalVariables.birthDate,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          GlobalVariables.civilId,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 5, left: 10),
                                        child: BarcodeWidget(
                                          barcode: Barcode.code128(),
                                          data: GlobalVariables.civilId,
                                          drawText: false,
                                          height: 50,
                                          width: 180,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => const DocumentScreen());
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    width: 1,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Бичиг баримт",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black.withOpacity(0.2),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
