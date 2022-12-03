import 'package:flutter/material.dart';
import 'package:gerege_app_v2/controller/sumni_scanner.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
import 'package:get/get.dart';

// import 'package:sunmi_barcode_scanner/sunmi_barcode_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final String _scanBarcode = 'Unknown';
  var searchController = TextEditingController();

  RxList driverList = [].obs;
  // final SunmiController _sunmiController = Get.find();
  final SunmiController _sunmiController = Get.put(SunmiController());
  // String _modelVersion = 'Unknown';
  // var sunmiBarcodeScanner = SunmiBarcodeScanner();

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    // sunmiBarcodeScanner.onBarcodeScanned().listen((event) {
    //   print('adsadads');
    //   print(event);
    //   searchUser(event, false);
    // });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String modelVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     modelVersion = (await sunmiBarcodeScanner.getScannerModel()).toString();
  //   } on PlatformException {
  //     modelVersion = 'Failed to get model version.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _modelVersion = modelVersion;
  //     print('model version');
  //     print(_modelVersion);
  //     print('model versiossn');
  //   });
  // }

  searchUser(text, type) {
    // {{DOMAIN}}/user/find?search_text=вю96042818
    String url = '${CoreUrl.serviceUrl}user/find?search_text=$text';
    print(url);
    Services().getRequest(url, true, '').then((data) {
      print('ywsanbh');
      print(text);
      print(data.body);
      if (data.body['message'] == "success") {
        driverList.add(data.body['result']);
        print(driverList);
        if (type == true) {
          print('sda');
          Get.back();
        }
        Get.snackbar(
          'success_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.2),
        );
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.2),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ///sunmi reader unshad bj bn
    if (GlobalVariables.usePos != "0") {
      ever(_sunmiController.codeVal, (value) {
        setState(() {
          print("$value end utga oorchlgdd bn l da");
          searchUser(value, false);
        });
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomSheet: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 20),
        child: GlobalVariables.usePos == "0"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        addDriverModal();
                      });
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(5.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.add,
                      size: 35.0,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      // startBarcodeScanStream();

                      // scanBarcode();
                      var barCodeData = await Reader().scannerQrBarCode();
                      if (barCodeData != "-1") {
                        searchUser(barCodeData, false);
                      }
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(5.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 35.0,
                    ),
                  )
                ],
              )
            : RawMaterialButton(
                onPressed: () {
                  setState(() {
                    addDriverModal();
                  });
                },
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(5.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  size: 35.0,
                ),
              ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text(
              "Жолоочын жагсаалт",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: driverWidget(),
          )
        ],
      ),
    );
  }

  Widget driverWidget() {
    return Obx(
      () => ListView.builder(
        itemCount: driverList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Овог нэр: ${driverList[index]['last_name'].toString().capitalizeCustom()} ${driverList[index]['first_name'].toString().capitalizeCustom()}",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.black.withOpacity(0.2),
                      )
                    ],
                  ),
                ],
              ));
        },
      ),
    );
  }

  addDriverModal() {
    searchController.text = "";
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Жолооч бүртгэл'),
        actions: [
          Column(
            children: [
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.text,
                controller: searchController,
                decoration: InputDecoration(
                  counterText: "",
                  labelText: 'Регистер',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GeregeButtonWidget(
                    radius: 10.0,
                    elevation: 0.0,
                    height: 40,
                    minWidth: GlobalVariables.gWidth / 4,
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.black,
                    text: const Text(
                      'Буцах',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  const SizedBox(width: 10),
                  GeregeButtonWidget(
                    radius: 10.0,
                    elevation: 0.0,
                    height: 40,
                    minWidth: GlobalVariables.gWidth / 4,
                    backgroundColor: Colors.transparent,
                    borderColor: CoreColor().backgroundBlue,
                    text: Text(
                      'Нэмэх',
                      style: TextStyle(
                        color: CoreColor().backgroundBlue,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (searchController.text != '') {
                          searchUser(searchController.text, true);
                        } else {
                          Get.snackbar(
                            'warning_tr'.translationWord(),
                            "Регистер оруулна уу",
                            colorText: Colors.white,
                            backgroundColor: Colors.white.withOpacity(0.2),
                          );
                        }
                      });
                    },
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
