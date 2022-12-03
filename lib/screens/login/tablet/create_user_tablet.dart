import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
import 'package:gerege_app_v2/widget/gerege_textfield.dart';
import 'package:get/get.dart';
import 'package:gerege_app_v2/controller/create_user_controller.dart';

/// [CreateUserTabletScreen] create user screen

class CreateUserTabletScreen extends StatefulWidget {
  const CreateUserTabletScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<CreateUserTabletScreen> createState() => _CreateUserTabletScreenState();
}

class _CreateUserTabletScreenState extends State<CreateUserTabletScreen>
    with TickerProviderStateMixin {
  static final CreateUserController _createUserController =
      Get.put(CreateUserController());
  // var searchController = TextEditingController();
  // var emailController = TextEditingController();
  RxInt screenChange = 0.obs;

  var registerController = TextEditingController();
  var otpCodeController = TextEditingController();
  var passwordController = TextEditingController();
  late TabController tabController;

  int resendSecond = 60;
  int selectedIndex = 0;
  final formKey = GlobalKey<FormState>();
  RxList countryList = [].obs;

  String selectionCountry = "MNG";
  String selectionGender = "";

  var yearExpire = TextEditingController();
  var monthExpire = TextEditingController();
  var dayExpire = TextEditingController();

  var yearIssue = TextEditingController();
  var monthIssue = TextEditingController();
  var dayIssue = TextEditingController();

  var yearBirth = TextEditingController();
  var monthBirth = TextEditingController();
  var dayBirth = TextEditingController();

  var regNoController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var docNoController = TextEditingController();
  String selectCategoryId = "";
  String selectTypeId = "";

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {
        if (tabController.indexIsChanging) {
        } else {
          setState(() {
            selectedIndex = tabController.index;
          });
        }
      });
    });
    super.initState();
    // Рш();
    // getCountryList();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  otpSend() {
    String url =
        '${CoreUrl.serviceUrl}auth/identify?text=${_createUserController.searchController}';
    print(url);
    Services().getRequest(url, false, '').then((data) {
      if (data.statusCode == 200) {
        screenChange.value = 1;
        print('sda');
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

  register() {
    var bytes = utf8.encode(passwordController.text);
    var digest = md5.convert(bytes);
    var bodyData = {
      "identity": _createUserController.searchController,
      "password": digest.toString(),
      "otp": otpCodeController.text
    };
    print(bodyData);
    Services()
        .postRequest(bodyData, '${CoreUrl.serviceUrl}auth/register', false, '')
        .then((data) {
      // var res = json.decode(data.body);
      var res = data.body;
      if (data.statusCode == 200) {
        // print(res['authorization']['token']);
        // Get.back();
        GlobalVariables.gStorage
            .write("token", res['result']['authorization']['token']);
        GlobalVariables.gStorage
            .write('userInformation', res['result']['user']);
        GlobalVariables.storageToVar();
        getCountryList();
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: Colors.grey.withOpacity(0.2),
        );
      }
    });
  }

  timeoutCall() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSecond != 0) {
        setState(() {
          resendSecond--;
        });
      } else {
        setState(() {
          // screen Change.value == false;
        });
        timer.cancel();
      }
    });
  }

  getCountryList() {
    String url = '${CoreUrl.serviceUrl}countries?page_size=500&page_number=1';
    print("token ---------------------------------");
    print(GlobalVariables.gStorage.read("token"));

    Services().getRequest(url, true, '').then((data) {
      if (data.statusCode == 200) {
        setState(() {
          countryList.value = data.body['result']['items'];
          print(
              'country list orsoon -------------------------------------------------------------------');
          print(countryList);
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

//   {{DOMAIN}}/document/find

  documentFind() {
    var bodyMNG = {
      "country_code": selectionCountry,
      "reg_no": registerController.text,
    };
    var bodyOther = {
      "birth_date": yearBirth.text == ""
          ? ''
          : "${yearBirth.text}-${monthBirth.text}-${dayBirth.text}",

      "country_code": selectionCountry,
      "date_of_expiry":
          "${yearExpire.text}-${monthExpire.text}-${dayExpire.text}",
      "date_of_issue": "${yearIssue.text}-${monthIssue.text}-${dayIssue.text}",
      "document_number": docNoController.text,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "reg_no": "",
      "type_id": "",
      "category_id": "4", //selectCategoryId,

      "gender": selectionGender == "Эр" ? "1" : "0"
    };

    print("bodyMNG");
    print(bodyMNG);

    print("bodyOther");
    print(bodyOther);

    Services()
        .postRequest(
            json.encode(selectionCountry == "MNG" ? bodyMNG : bodyOther),
            '${CoreUrl.serviceUrl}document/find',
            true,
            '')
        .then((data) {
      Navigator.of(Get.overlayContext!).pop();
      var res = data.body;
      log(json.encode(data.body));
      print("body res");
      print(data.body);
      if (data.statusCode == 200) {
        print('kukukakak');
        print(data.body);
      } else {
        // Get.back();
        Get.snackbar(
          'warning_tr'.translationWord(),
          res['message'].toString(),
          backgroundColor: Colors.white60,
          colorText: Colors.black,
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
              ? screenZero()
              : screenChange.value == 1
                  ? screenOne()
                  : screenTwo(),
        ),
      ),
    );
  }

  Widget screenTwo() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Container(
            width: GlobalVariables.gWidth,
            padding: const EdgeInsets.all(10),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Улсын мэдээлэл',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => countryList.isNotEmpty
                      ? DropdownButtonFormField(
                          iconEnabledColor: CoreColor().backgroundBlue,
                          iconDisabledColor: CoreColor().backgroundBlue,
                          decoration: InputDecoration(
                            fillColor: CoreColor().backgroundBlue,
                            hintText: "",
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                                width: 1.0,
                              ),
                            ),
                          ),
                          isExpanded: true,
                          hint: Text(
                            'pass_type_tr'.translationWord(),
                          ),
                          items: countryList.map((value) {
                            return DropdownMenuItem(
                              value: value['iso_alpha_code_3'].toString(),
                              child: Text(
                                value['full_name'],
                              ),
                            );
                          }).toList(),
                          value: selectionCountry,
                          onChanged: (value) {
                            setState(() {
                              // var data = json.decode(json.encode(value));
                              // print(data);
                              selectionCountry = value.toString();
                              print(selectionCountry);
                            });
                          },
                        )
                      : Container(),
                ),
                const SizedBox(height: 20),
                selectionCountry == "MNG"
                    ? const Text(
                        'Регистрийн дугаар',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    : Container(),
                selectionCountry == "MNG"
                    ? const SizedBox(height: 10)
                    : Container(),
                selectionCountry == "MNG"
                    ? TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        controller: registerController,
                        decoration: InputDecoration(
                          labelText: ''.translationWord(),
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          selectionCountry != "MNG" ? foriegnUser() : Container(),
          const SizedBox(height: 10),
          GeregeButtonWidget(
            radius: 10.0,
            elevation: 0.0,
            minWidth: GlobalVariables.gWidth,
            backgroundColor: CoreColor().backgroundBlue,
            borderColor: CoreColor().backgroundBlue,
            text: const Text(
              'Илгээх',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              setState(() {
                print('ilgeh');
                documentFind();
              });
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget foriegnUser() {
    return Column(
      children: [
        Container(
          width: GlobalVariables.gWidth,
          padding: const EdgeInsets.all(10),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Үндсэн мэдээлэл',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Нэр',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.text,
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: ''.translationWord(),
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
              const SizedBox(height: 10),
              const Text(
                'Овог',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.text,
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: ''.translationWord(),
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
              const SizedBox(height: 10),
              const Text(
                'Хүйс',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              DropdownButtonFormField(
                iconEnabledColor: CoreColor().backgroundBlue,
                iconDisabledColor: CoreColor().backgroundBlue,
                decoration: InputDecoration(
                  fillColor: CoreColor().backgroundBlue,
                  hintText: "",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.2),
                      width: 1.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.2),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.2),
                      width: 1.0,
                    ),
                  ),
                ),
                isExpanded: true,
                hint: Text(
                  ''.translationWord(),
                ),
                items: ['Эр', 'Эм'].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    print('ssdhuis');
                    print(value);
                    selectionGender = value.toString();
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Төрсөн огноо',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Огноо хоосон байж болохгүй';
                          }
                          if (!RegExp(r'[0-9]{4}$').hasMatch(value)) {
                            return 'Огноо буруу байна!!!';
                          }
                          if (int.parse(value) < 1900) {
                            return 'Огноо буруу байна!!! ';
                          }
                          return null;
                        },
                        autofocus: false,
                        controller: yearBirth,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'YYYY',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Сар хоосон байж болохгүй';
                          }
                          if (!RegExp(r'[0-9]{2}$').hasMatch(value)) {
                            return 'Сар буруу байна!!!';
                          }
                          if (int.parse(value) > 12) {
                            return 'Сар буруу байна!!! ';
                          }
                          return null;
                        },
                        maxLength: 2,
                        autofocus: false,
                        controller: monthBirth,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'MM',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Өдөр хоосон байж болохгүй';
                          }
                          if (!RegExp(r'[0-9]{2}$').hasMatch(value)) {
                            return 'Өдөр буруу байна!!!';
                          }
                          if (int.parse(value) > 31) {
                            return 'Өдөр буруу байна!!! ';
                          }
                          return null;
                        },
                        maxLength: 2,
                        autofocus: false,
                        controller: dayBirth,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'DD',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: GlobalVariables.gWidth,
          padding: const EdgeInsets.all(10),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Пасспортын мэдээлэл',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Пасспортын дугаар',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.text,
                controller: docNoController,
                decoration: InputDecoration(
                  labelText: ''.translationWord(),
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
              const SizedBox(height: 10),
              const Text(
                'Пасспорт олгосон огноо',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Огноо хоосон байж болохгүй';
                          }
                          if (!RegExp(r'[0-9]{4}$').hasMatch(value)) {
                            return 'Огноо буруу байна!!!';
                          }
                          if (int.parse(value) < 1900) {
                            return 'Огноо буруу байна!!! ';
                          }
                          return null;
                        },
                        autofocus: false,
                        controller: yearIssue,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'YYYY',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Сар хоосон байж болохгүй';
                          }
                          if (!RegExp(r'[0-9]{2}$').hasMatch(value)) {
                            return 'Сар буруу байна!!!';
                          }
                          if (int.parse(value) > 12) {
                            return 'Сар буруу байна!!! ';
                          }
                          return null;
                        },
                        maxLength: 2,
                        autofocus: false,
                        controller: monthIssue,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'MM',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Өдөр хоосон байж болохгүй';
                          }
                          if (!RegExp(r'[0-9]{2}$').hasMatch(value)) {
                            return 'Өдөр буруу байна!!!';
                          }
                          if (int.parse(value) > 31) {
                            return 'Өдөр буруу байна!!! ';
                          }
                          return null;
                        },
                        maxLength: 2,
                        autofocus: false,
                        controller: dayIssue,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'DD',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Пасспорт дуусах огноо',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Огноо хоосон байж болохгүй';
                          }
                          if (!RegExp(r'[0-9]{4}$').hasMatch(value)) {
                            return 'Огноо буруу байна!!!';
                          }
                          if (int.parse(value) < 1900) {
                            return 'Огноо буруу байна!!! ';
                          }
                          return null;
                        },
                        autofocus: false,
                        controller: yearExpire,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'YYYY',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Сар хоосон байж болохгүй';
                          }
                          if (!RegExp(r'[0-9]{2}$').hasMatch(value)) {
                            return 'Сар буруу байна!!!';
                          }
                          if (int.parse(value) > 12) {
                            return 'Сар буруу байна!!! ';
                          }
                          return null;
                        },
                        maxLength: 2,
                        autofocus: false,
                        controller: monthExpire,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'MM',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Өдөр хоосон байж болохгүй';
                          }
                          if (!RegExp(r'[0-9]{2}$').hasMatch(value)) {
                            return 'Өдөр буруу байна!!!';
                          }
                          if (int.parse(value) > 31) {
                            return 'Өдөр буруу байна!!! ';
                          }
                          return null;
                        },
                        maxLength: 2,
                        autofocus: false,
                        controller: dayExpire,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'DD',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget screenZero() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              width: 340,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.0),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  indicatorColor: CoreColor().backgroundButton,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  controller: tabController,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontFamily: "MRegular",
                  ),
                  tabs: [
                    Tab(
                      text: 'email_tr'.translationWord(),
                    ),
                    Tab(
                      text: 'phone_num_tr'.translationWord(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      selectedIndex == 0
                          ? GeregeTextField(
                              controller:
                                  _createUserController.searchController!,
                              label: 'email_tr',
                              keyboardType: TextInputType.emailAddress,
                            )
                          : Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.black.withOpacity(0.2),
                                        width: 1),
                                  ),
                                  width: 90,
                                  child: const Text(
                                    '+976',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        _createUserController.searchController!,
                                    autofocus: false,
                                    keyboardType: TextInputType.number,
                                    maxLength: 8,
                                    validator: (String? val) =>
                                        GlobalValidator().phoneValid(val),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      labelText:
                                          'phone_num_tr'.translationWord(),
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                      contentPadding: const EdgeInsets.all(20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      GeregeButtonWidget(
                        radius: 10.0,
                        elevation: 0.0,
                        minWidth: GlobalVariables.gWidth,
                        backgroundColor: CoreColor().backgroundBlue,
                        borderColor: CoreColor().backgroundBlue,
                        text: Text(
                          'otp_send_tr'.translationWord(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            // otpSend();
                            await _createUserController.otpSend(context).then(
                              (data) {
                                if (data.statusCode == 200) {
                                  screenChange.value = 1;
                                }
                              },
                            );
                          }
                          // setState(() {
                          // });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget screenOne() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      readOnly: true,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      controller: _createUserController.searchController!,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.withOpacity(0.2),
                        filled: true,
                        labelText: ''.translationWord(),
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.all(20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'password_tr'.translationWord(),
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.all(20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      controller: otpCodeController,
                      decoration: InputDecoration(
                        labelText: 'otp_tr'.translationWord(),
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.all(20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          GeregeButtonWidget(
            radius: 10.0,
            elevation: 0.0,
            minWidth: 300,
            backgroundColor: CoreColor().backgroundYellow,
            borderColor: CoreColor().backgroundYellow,
            text: Text(
              'otp_send_tr'.translationWord(),
              style: const TextStyle(),
            ),
            onPressed: () {
              setState(() {
                // register
                if (_createUserController.searchController != "" &&
                    otpCodeController.text != "" &&
                    passwordController.text != "") {
                  register();
                } else {
                  Get.snackbar(
                    'warning_tr'.translationWord(),
                    "Талбаруудыг бөглөнө үү",
                    colorText: Colors.white,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }
}