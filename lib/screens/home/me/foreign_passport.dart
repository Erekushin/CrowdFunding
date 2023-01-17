import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/home/me/document_screen.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

import '../../../helpers/services.dart';
import '../../../widget/fundamental/btn.dart';

class ForeignPassScreen extends StatefulWidget {
  const ForeignPassScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ForeignPassScreen> createState() => _ForeignPassScreenState();
}

class _ForeignPassScreenState extends State<ForeignPassScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isParsed = false;
  RxBool screenChange = true.obs;
  RxBool codeScreen = false.obs;

  List passportType = [];

  List passportCategory = [];

  bool flashLight = false;
  int resendSecond = 60;

  bool step = false;

  var passportNumberController = TextEditingController();
  var nationalityController = TextEditingController();

  var yearExpire = TextEditingController();
  var monthExpire = TextEditingController();
  var dayExpire = TextEditingController();

  var yearIssue = TextEditingController();
  var monthIssue = TextEditingController();
  var dayIssue = TextEditingController();

  String selectedCategory = "";
  String selectedPassType = "";

  @override
  void initState() {
    super.initState();
    getCategory();
    getType();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCategory() {
    String url = '${CoreUrl.crowdfund}document/category';
    Services().getRequest(url, true, '').then((data) {
      if (data.statusCode == 200) {
        setState(() {
          passportCategory = data.body['result']['items'];
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

  getType() {
    String url = '${CoreUrl.crowdfund}document/type?category_id=1';
    Services().getRequest(url, true, '').then((data) {
      if (data.statusCode == 200) {
        setState(() {
          passportType = data.body['result']['items'];
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

  String time(date) {
    var dateValue = DateFormat("yyyy-MM-ddTHH:mm:ss").parseUTC(date);
    String formattedDate = DateFormat("yyyy-MM-dd").format(dateValue);
    return formattedDate;
  }

  void _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      updatePassport();
    }
  }

// find document POST
// {

// }
  updatePassport() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var bodyData = {
      "birth_date": GlobalVariables.birthDate,
      "category_id": selectedCategory,
      "country_code": GlobalVariables.countryCode,
      "date_of_issue":
          "${yearExpire.text}-${monthExpire.text}-${dayExpire.text}",
      "date_of_expire": "${yearIssue.text}-${monthIssue.text}-${dayIssue.text}",
      "document_number": passportNumberController.text,
      "first_name": GlobalVariables.firstName,
      "last_name": GlobalVariables.lastName,
      "reg_no": GlobalVariables.regNo,
      "type_id": selectedPassType,
      "user_id": GlobalVariables.id,
    };
    Services()
        .postRequest(json.encode(bodyData), "${CoreUrl.crowdfund}document/find",
            true, "")
        .then((data) {
      if (data.statusCode == 200) {
        Get.to(() => const DocumentScreen());
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: CoreColor().backgroundBlue,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Пасспорт нэмэх",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              stepOne(),
            ],
          ),
        ),
      ),
    );
  }

  Widget stepOne() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "pass_category_tr".translationWord(),
            ),
          ),
          DropdownButtonFormField(
            validator: (value) {
              if (value == null) {
                return 'Please passport category';
              }
              return null;
            },
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
              'pass_category_tr'.translationWord(),
            ),
            items: passportCategory.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value['name'],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                var data = json.decode(json.encode(value));

                selectedCategory = data['id'].toString();
              });
            },
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "pass_type_tr".translationWord(),
            ),
          ),
          DropdownButtonFormField(
            validator: (value) {
              if (value == null) {
                return 'Please passport type';
              }
              return null;
            },
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
              'pass_type_tr'.translationWord(),
            ),
            items: passportType.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value['name'],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                var data = json.decode(json.encode(value));

                selectedPassType = data['id'].toString();
              });
            },
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "passport_number_tr".translationWord(),
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please passport number';
              }
              return null;
            },
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: passportNumberController,
            decoration: InputDecoration(
              counterText: "",
              labelText: 'passport_number_tr'.translationWord(),
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
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "issue_tr".translationWord(),
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
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "expire_tr".translationWord(),
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
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "nationality_tr".translationWord(),
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please nationality ';
              }
              return null;
            },
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: nationalityController,
            decoration: InputDecoration(
              counterText: "",
              labelText: 'nationality_tr'.translationWord(),
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
          generalBtn(CoreColor().backgroundGreen, CoreColor().backgroundGreen,
              'new_user_tr'.translationWord(), () {
            setState(() {
              _trySubmitForm();
            });
          }),
        ],
      ),
    );
  }
}
