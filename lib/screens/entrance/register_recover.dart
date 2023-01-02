import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/entrance.dart';
import '../../helpers/core_url.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/logging.dart';
import '../../services/get_service.dart';
import '../../style/color.dart';
import '../../widget/appbar_squeare.dart';
import '../../widget/btn.dart';
import '../../widget/gerege_button.dart';
import '../../widget/options.dart';
import '../../widget/txt_field.dart';
import '../content_home/home.dart';

// ignore: camel_case_types
class Register_Recover extends StatefulWidget {
  const Register_Recover({super.key, required this.route});
  final String route;
  @override
  State<Register_Recover> createState() => _Register_RecoverState();
}

// ignore: camel_case_types
class _Register_RecoverState extends State<Register_Recover> {
  final crowdlog = logger(Register_Recover);
  final cont = Get.put(Entrance());
  var nullTxt = TextEditingController();
  var scrollCont = ScrollController();

  String selectionCountry = "MNG";
  String selectionGender = "Эр";
  @override
  void initState() {
    if (widget.route == 'login') {
      cont.recieverTypeVis.value = true;
    }
    super.initState();
  }

  jumptobottom() async {
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollCont.animateTo(scrollCont.position.maxScrollExtent,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 500));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarSquare(
        height: GlobalVariables.gWidth * .4,
        leadingIcon: const Icon(
          FontAwesomeIcons.chevronLeft,
          color: Colors.black,
          size: 18,
        ),
        menuAction: () {
          Get.back();
        },
        titleColor: Colors.black,
        color: Colors.white,
        title: 'Бүртгүүлэх',
      ),
      body: GetX<Entrance>(
        builder: (littleCont) {
          return SingleChildScrollView(
            controller: scrollCont,
            child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  children: [
                    box('Нууц үг үүсгэх аргаа сонгоно уу', registerSeq1(),
                        cont.recieverTypeVis.value),
                    box(
                        'Өөрийн ашигладаг утасны дугаараа оруулна уу',
                        registerSeq2(
                            1,
                            cont.phoneTxt,
                            nullTxt,
                            nullTxt,
                            '99999999',
                            '',
                            '',
                            CoreColor.mainGreen,
                            'Нууц дугаар авах', () {
                          jumptobottom();
                          cont.otpSend('Утас');
                        }),
                        cont.phoneVis.value),
                    box(
                        'Өөрийн ашигладаг е-мэйл хаягаа оруулна уу',
                        registerSeq2(
                            1,
                            cont.emailTxt,
                            nullTxt,
                            nullTxt,
                            'hello@exaple.com',
                            '',
                            '',
                            CoreColor.mainGreen,
                            'Нууц дугаар авах', () async {
                          await cont.otpSend('Е-Мэйл');
                          jumptobottom();
                        }),
                        cont.emailVis.value),
                    box(
                        'Хүлээн авсан нууц дугаарыг, өөрийн цаашид ашиглах нууц дугаарын хамтаар оруулна уу',
                        registerSeq2(
                            3,
                            cont.otpTxt,
                            cont.passTxt,
                            cont.passVerifyTxt,
                            'otp код',
                            'нууц дугаар',
                            'нууц дугаар давтах',
                            CoreColor.mainGreen,
                            'Бүртгэл үүсгэх', () async {
                          await cont.register();
                          jumptobottom();
                        }),
                        cont.otpVis.value),
                    box(
                        'Иргэний мэдээлэл',
                        registerSeq3(
                            cont.rdtxt,
                            'Регистрийн дугаараа оруулна уу',
                            CoreColor.mainGreen,
                            Colors.grey.withOpacity(.7),
                            'илгээх',
                            'алгасах', () async {
                          await cont
                              .documentFind(
                                  context, selectionCountry, selectionGender)
                              .then((data) {
                            if (data.statusCode == 200) {
                              // Get.to(() => const MainTab(indexTab: 0));
                              Get.to(() => const ContentHome());
                            } else {}
                          });
                        }, () {
                          Get.to(() => const ContentHome());
                        }),
                        cont.citizenInfoVis.value),
                  ],
                )),
          );
        },
      ),
    );
  }

  Widget spacerLine() {
    return Container(
      margin: const EdgeInsets.all(10),
      width: GlobalVariables.gWidth * .8,
      height: 1,
      color: Colors.black45,
    );
  }

  Widget datePicker(String title, String titleVal) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(), //get today's date
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));
        if (pickedDate != null) {
          setState(() {
            switch (title) {
              case 'Төрсөн огноо':
                cont.birthday =
                    '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';

                break;
              case 'Паспорт олгосон огноо':
                cont.givenDay =
                    '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                break;
              case 'Паспорт дуусах огноо':
                cont.expiredDay =
                    '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                break;
              default:
            }
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.15),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: GlobalVariables.gWidth * .5,
              child: Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                '$title: $titleVal',
                style: GoogleFonts.sourceSansPro(
                  height: 2,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ),
            const Icon(
              FontAwesomeIcons.pen,
              color: Colors.grey,
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget box(String title, Widget chilaka, bool visibility) {
    return Visibility(
      visible: visibility,
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.all(25),
        width: GlobalVariables.gWidth * .9,
        decoration: BoxDecoration(
            color: const Color(0XFFF8F8F8),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
                blurStyle: BlurStyle.outer,
              )
            ]),
        child: Column(
          children: [
            Text(title),
            spacerLine(),
            const SizedBox(
              height: 15,
            ),
            chilaka
          ],
        ),
      ),
    );
  }

  Widget registerSeq1() {
    var listdata = <String>['Утас', 'Е-Мэйл'];
    return SizedBox(
        child: OptionsHorizontal(
            valueList: listdata,
            selected: '',
            func: (value) {
              if (value == "Утас") {
                cont.phoneVis.value = true;
                cont.emailVis.value = false;
              } else if (value == "Е-Мэйл") {
                cont.emailVis.value = true;
                cont.phoneVis.value = false;
              }
            }));
  }

  Widget registerSeq2(
      int type,
      TextEditingController txtCont1,
      TextEditingController txtCont2,
      TextEditingController txtCont3,
      String lbl1,
      String lbl2,
      String lbl3,
      btnClr,
      btnTitle,
      Function func) {
    switch (type) {
      case 1:
        return Column(
          children: [
            Container(
              child: txtField2(txtCont1, lbl1, () {}),
            ),
            const SizedBox(
              height: 15,
            ),
            generalBtn(btnClr, btnTitle, func)
          ],
        );
      case 3:
        return Column(
          children: [
            Container(
              child: txtField2(txtCont1, lbl1, () {}),
            ),
            Container(
              child: txtField2(txtCont2, lbl2, () {}),
            ),
            Container(
              child: txtField2(txtCont3, lbl3, () {}),
            ),
            const SizedBox(
              height: 15,
            ),
            generalBtn(btnClr, btnTitle, func)
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget registerSeq3(
      TextEditingController txtCont1,
      String lbl1,
      Color btnClr1,
      Color btnClr2,
      String btnTitle1,
      String btnTitle2,
      Function func1,
      Function func2) {
    return Column(
      children: [
        //#region drop resource
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => DropdownButton(
                iconEnabledColor: CoreColor.mainGreen,
                iconDisabledColor: CoreColor.mainGreen,
                value: selectionCountry,
                isExpanded: true,
                hint: Text(
                  'pass_type_tr'.translationWord(),
                ),
                items: cont.countryList.map((value) {
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
            selectionCountry != "MNG" ? foriegnUser() : const SizedBox(),
          ],
        ),
        //#endregion

        selectionCountry == "MNG"
            ? Container(
                child: txtField2(txtCont1, lbl1, () {}),
              )
            : const SizedBox(),
        const SizedBox(
          height: 15,
        ),
        generalBtn(btnClr1, btnTitle1, func1),
        const SizedBox(
          height: 15,
        ),
        generalBtn(btnClr2, btnTitle2, func2)
      ],
    );
  }

  Widget foriegnUser() {
    return Column(
      children: [
        const Text(
          'Үндсэн мэдээлэл',
        ),
        spacerLine(),
        txtField2(cont.lastNameController, 'Нэр', () {}),
        txtField2(cont.firstNameController, 'Овог', () {}),
        const SizedBox(height: 10),
        DropdownButton(
          iconEnabledColor: CoreColor.mainGreen,
          iconDisabledColor: CoreColor.mainGreen,
          isExpanded: true,
          hint: const Text(
            'Хүйс',
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
        datePicker('Төрсөн огноо', cont.birthday),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        const Text(
          'Паспортын мэдээлэл',
        ),
        spacerLine(),
        txtField2(cont.docNoController, 'Паспортын дугаар', () {}),
        datePicker('Паспорт олгосон огноо', cont.givenDay),
        datePicker('Паспорт дуусах огноо', cont.expiredDay),
      ],
    );
  }
}
