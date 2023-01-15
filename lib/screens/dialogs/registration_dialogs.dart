import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/entrance.dart';
import '../../global_players.dart';
import '../../helpers/gvariables.dart';
import '../../style/color.dart';
import '../../widget/btn.dart';
import '../../widget/txt_field.dart';
import '../content_home/home.dart';

var auth = Get.find<EntranceCont>();
String selectionCountry = "MNG";

Object dialogy(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    pageBuilder: (context, anim1, anim2) {
      return StatefulBuilder(builder: (context, setState) {
        return Center(
          child: SizedBox(
            width: GlobalVariables.gWidth * .9,
            height: GlobalVariables.gHeight * .9,
            child: StatefulBuilder(
              builder: (context, snapshot) {
                return Card(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: 200,
                                child:
                                    Image.asset('assets/images/success.png')),
                            InkWell(
                              onTap: () {
                                Get.offAll(() => const ContentHome());
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Icon(
                                  FontAwesomeIcons.x,
                                  color: Colors.black,
                                  size: Sizes.iconSize,
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          color: Colors.grey.withOpacity(.3),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(
                              bottom: 10, top: 10, left: 30, right: 30),
                          child: const Text(
                            'Бүртгэл амжилттай үүслээ та өөрийн иргэний мэдээллийг профайлын setting хэсэг рүү орон холбох боломжтой',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.lightbulb,
                              color: Colors.yellow,
                              size: Sizes.iconSize,
                            ),
                            const SizedBox(width: 10),
                            const SizedBox(
                              width: 200,
                              child: Text(
                                'Таний иргэний мэдээлэл хамгаалагдсан болно.',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Obx(
                            () => DropdownButton(
                              iconEnabledColor: CoreColor.mainPurple,
                              iconDisabledColor: CoreColor.mainPurple,
                              value: selectionCountry,
                              isExpanded: true,
                              hint: Text(
                                'pass_type_tr'.translationWord(),
                              ),
                              items: auth.countryList.map((value) {
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
                        ),
                        const SizedBox(height: 20),
                        selectionCountry != "MNG"
                            ? Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: foriegnUser(context))
                            : const SizedBox(),
                        //#endregion

                        selectionCountry == "MNG"
                            ? Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: txtField2(auth.rdtxt,
                                    'Регистрийн дугаараа оруулна уу'),
                              )
                            : const SizedBox(),

                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: generalBtn(CoreColor.mainPurple, 'илгээх', () {
                            auth.documentFind(
                                context, selectionCountry, selectionGender);
                          }),
                        )
                      ],
                    ),
                  ),
                );
                ;
              },
            ),
          ),
        );
      });
    },
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
            child: txtField2(txtCont1, lbl1),
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
          txtField2(txtCont1, lbl1),
          TxtFieldPass(txtCont: txtCont2, hinttxt: lbl2),
          TxtFieldPass(txtCont: txtCont3, hinttxt: lbl3),
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

String selectionGender = "Эр";
Widget foriegnUser(BuildContext context) {
  return Column(
    children: [
      const Text(
        'Үндсэн мэдээлэл',
      ),
      spacerLine(),
      txtField2(auth.lastNameController, 'Нэр'),
      txtField2(auth.firstNameController, 'Овог'),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: DropdownButton(
          iconEnabledColor: CoreColor.mainPurple,
          iconDisabledColor: CoreColor.mainPurple,
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
            selectionGender = value.toString();
          },
        ),
      ),
      datePicker('Төрсөн огноо', auth.birthday, context),
      const SizedBox(height: 10),
      const SizedBox(height: 10),
      const Text(
        'Паспортын мэдээлэл',
      ),
      spacerLine(),
      txtField2(auth.docNoController, 'Паспортын дугаар'),
      datePicker('Паспорт олгосон огноо', auth.givenDay, context),
      datePicker('Паспорт дуусах огноо', auth.expiredDay, context),
    ],
  );
}

Widget datePicker(String title, String titleVal, BuildContext context) {
  return InkWell(
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(), //get today's date
          firstDate: DateTime(
              2000), //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime(2101));
      if (pickedDate != null) {
        switch (title) {
          case 'Төрсөн огноо':
            auth.birthday =
                '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';

            break;
          case 'Паспорт олгосон огноо':
            auth.givenDay =
                '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
            break;
          case 'Паспорт дуусах огноо':
            auth.expiredDay =
                '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
            break;
          default:
        }
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

Object phoneDialogy(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    pageBuilder: (context, anim1, anim2) {
      return StatefulBuilder(builder: (context, setState) {
        return Center(
          child: SizedBox(
            width: GlobalVariables.gWidth * .9,
            height: GlobalVariables.gHeight * .5,
            child: StatefulBuilder(
              builder: (context, snapshot) {
                return Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Text('data')],
                  ),
                );
                ;
              },
            ),
          ),
        );
      });
    },
  );
}

Object failedDialogy(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    pageBuilder: (context, anim1, anim2) {
      return StatefulBuilder(builder: (context, setState) {
        return Center(
          child: SizedBox(
            width: GlobalVariables.gWidth * .9,
            height: GlobalVariables.gHeight * .5,
            child: StatefulBuilder(
              builder: (context, snapshot) {
                return Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              width: 200,
                              child: Image.asset('assets/images/success.png')),
                          InkWell(
                            onTap: () {
                              Get.offAll(() => const ContentHome());
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Icon(
                                FontAwesomeIcons.x,
                                color: Colors.black,
                                size: Sizes.iconSize,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        color: Colors.grey.withOpacity(.3),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(
                            bottom: 10, top: 10, left: 30, right: 30),
                        child: const Text(
                          'Бүртгэл амжилттай үүслээ та өөрийн иргэний мэдээллийг профайлын setting хэсэг рүү орон холбох боломжтой',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.lightbulb,
                            color: Colors.yellow,
                            size: Sizes.iconSize,
                          ),
                          const SizedBox(width: 10),
                          const SizedBox(
                            width: 200,
                            child: Text(
                              'Таний иргэний мэдээлэл хамгаалагдсан болно.',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Get.offAll(() => const ContentHome());
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 40, right: 40),
                          decoration: BoxDecoration(
                              color: CoreColor.mainPurple,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: const Text(
                            "Нэвтрэх",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                );
                ;
              },
            ),
          ),
        );
      });
    },
  );
}
