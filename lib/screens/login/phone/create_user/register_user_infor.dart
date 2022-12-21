import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/controller/create_user_controller.dart';
import 'package:get/get.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import '../../../content_home/home.dart';
import '../../../main_tab.dart';

class RegisterUserInfor extends StatefulWidget {
  const RegisterUserInfor({Key? key, this.onPressed, required this.countryList})
      : super(key: key);

  final Function(int)? onPressed;
  final List countryList;

  @override
  State<RegisterUserInfor> createState() => _RegisterUserInfor();
}

class _RegisterUserInfor extends State<RegisterUserInfor> {
  static final CreateUserController _createUserController =
      Get.put(CreateUserController());

  String selectionCountry = "MNG";
  String selectionGender = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  () => DropdownButtonFormField(
                    iconEnabledColor: CoreColor().backgroundBlue,
                    iconDisabledColor: CoreColor().backgroundBlue,
                    value: selectionCountry,
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
                    items: widget.countryList.map((value) {
                      return DropdownMenuItem(
                        value: value['iso_alpha_code_3'],
                        child: Text(
                          value['full_name'],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectionCountry = value.toString();
                      });
                    },
                  ),
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
                        controller: _createUserController.registerController,
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
            onPressed: () async {
              await _createUserController
                  .documentFind(context, selectionCountry, selectionGender)
                  .then((data) {
                if (data.statusCode == 200) {
                  // Get.to(() => const MainTab(indexTab: 0));
                  Get.to(() => const ContentHome());
                } else {}
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
                controller: _createUserController.lastNameController,
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
                controller: _createUserController.firstNameController,
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
                        controller: _createUserController.yearBirth,
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
                        controller: _createUserController.monthBirth,
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
                        controller: _createUserController.dayBirth,
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
                controller: _createUserController.docNoController,
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
                        controller: _createUserController.yearIssue,
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
                        controller: _createUserController.monthIssue,
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
                        controller: _createUserController.dayIssue,
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
                        controller: _createUserController.yearExpire,
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
                        controller: _createUserController.monthExpire,
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
                        controller: _createUserController.dayExpire,
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
}
