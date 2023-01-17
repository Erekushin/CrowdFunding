import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/entrance.dart';
import '../../global_players.dart';
import '../../helpers/backHelper.dart';
import '../../helpers/gvariables.dart';
import '../../style/color.dart';
import '../../widget/combos/appbar_squeare.dart';
import '../../widget/fundamental/btn.dart';
import '../../widget/fundamental/options.dart';
import '../../widget/fundamental/txt_field.dart';
import '../content_home/home.dart';

// ignore: camel_case_types
class Register_Recover extends StatefulWidget {
  const Register_Recover({super.key, required this.title});
  final String title;
  @override
  State<Register_Recover> createState() => _Register_RecoverState();
}

// ignore: camel_case_types
class _Register_RecoverState extends State<Register_Recover> {
  final crowdlog = logger(Register_Recover);
  final cont = Get.put(EntranceCont());

  String title = '';
  String caseEmail = '';
  String casePhone = '';
  @override
  void initState() {
    if (widget.title == 'Бүртгүүлэх') {
      cont.recieverTypeVis.value = true;
      title = 'Нууц үг үүсгэх аргаа сонгоно уу';
      caseEmail = 'Өөрийн ашигладаг е-мэйл хаягаа оруулна уу';
      casePhone = 'Өөрийн ашигладаг утасны дугаараа оруулна уу';
    } else if (widget.title == 'Нууц үг сэргээх') {
      cont.recieverTypeVis.value = true;
      title = 'Нууц үг сэргээх аргаа сонгоно уу';
      caseEmail = 'Өөрийн бүртгэлтэй е-мэйл хаягаа оруулна уу';
      casePhone = 'Өөрийн бүртгэлтэй утасны дугаараа оруулна уу';
    }
    super.initState();
  }

//#region helper funcs
  var scrollCont = ScrollController();
  jumptobottom() async {
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollCont.animateTo(scrollCont.position.maxScrollExtent,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 500));
    });
  }

//#endregion

  var nullTxt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        cont.cleanRegisterInfo();
        return true;
      },
      child: Scaffold(
        appBar: AppbarSquare(
          height: GlobalVariables.gHeight * .12,
          leadingIcon: const SizedBox(),
          menuAction: () {
            cont.cleanRegisterInfo();
            Get.back();
          },
          titleColor: Colors.black,
          color: Colors.white,
          title: widget.title,
        ),
        body: GetX<EntranceCont>(
          builder: (littleCont) {
            return SingleChildScrollView(
              controller: scrollCont,
              child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    children: [
                      box(title, registerSeq1(), cont.recieverTypeVis.value),
                      box(
                          casePhone,
                          registerSeq2(
                              1,
                              cont.phoneTxt,
                              nullTxt,
                              nullTxt,
                              '99999999',
                              '',
                              '',
                              CoreColor.mainPurple,
                              'Нууц дугаар авах', () {
                            cont.otpSend(
                                widget.title,
                                'Утас',
                                widget.title == 'Бүртгүүлэх'
                                    ? 'auth/identify?text='
                                    : 'auth/password?identity=');
                            jumptobottom();
                          }),
                          cont.phoneVis.value),
                      box(
                          caseEmail,
                          registerSeq2(
                              1,
                              cont.emailTxt,
                              nullTxt,
                              nullTxt,
                              'hello@exaple.com',
                              '',
                              '',
                              CoreColor.mainPurple,
                              'Нууц дугаар авах', () async {
                            await cont.otpSend(
                                widget.title,
                                'Е-Мэйл',
                                widget.title == 'Бүртгүүлэх'
                                    ? 'auth/identify?text='
                                    : 'auth/password?identity=');
                            cont.otpTxt.clear();
                            cont.passTxt.clear();
                            cont.passVerifyTxt.clear();
                            jumptobottom();
                          }),
                          cont.emailVis.value),
                      box(
                          'Хүлээн авсан нууц дугаарыг, өөрийн цаашид ашиглах нууц кодын хамтаар оруулна уу!',
                          registerSeq2(
                              3,
                              cont.otpTxt,
                              cont.passTxt,
                              cont.passVerifyTxt,
                              'otp код',
                              'нууц дугаар',
                              'нууц дугаар давтах',
                              CoreColor.mainPurple,
                              'Бүртгүүлэх', () async {
                            await cont.register(context);
                          }),
                          cont.otpVis.value),
                      box(
                          'Хүлээн авсан нууц дугаарыг, өөрийн цаашид ашиглах нууц кодын хамтаар оруулна уу!',
                          registerSeq2(
                              3,
                              cont.otpTxt,
                              cont.passTxt,
                              cont.passVerifyTxt,
                              'otp код',
                              'нууц дугаар',
                              'нууц дугаар давтах',
                              CoreColor.mainPurple,
                              'Нууц үг сэргээх', () async {
                            await cont.resetPassword();
                          }),
                          cont.otpVisRecover.value),
                      Visibility(
                        visible: cont.loading.value,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  )),
            );
          },
        ),
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

                cont.otpVis = false.obs;
                cont.otpVisRecover = false.obs;
                cont.loading = false.obs;
                cont.phoneTxt.clear();
                cont.emailTxt.clear();
                cont.otpTxt.clear();
                cont.passTxt.clear();
                cont.passVerifyTxt.clear();
                cont.registerText = '';
              } else if (value == "Е-Мэйл") {
                cont.emailVis.value = true;
                cont.phoneVis.value = false;
                cont.otpVis = false.obs;
                cont.otpVisRecover = false.obs;
                cont.loading = false.obs;
                cont.phoneTxt.clear();
                cont.emailTxt.clear();
                cont.otpTxt.clear();
                cont.passTxt.clear();
                cont.passVerifyTxt.clear();
                cont.registerText = '';
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
              child: txtField2(txtCont1, lbl1),
            ),
            const SizedBox(
              height: 15,
            ),
            generalBtn(btnClr, Colors.white, btnTitle, func)
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
            generalBtn(btnClr, Colors.white, btnTitle, func)
          ],
        );
      default:
        return const SizedBox();
    }
  }

  String selectionCountry = "MNG";
  Object dialogy() {
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
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              cont.cleanRegisterInfo();
                              Get.offAll(() => const ContentHome());
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 40, right: 40),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: const Text(
                                "алгасах",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
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
                          ),
                          const SizedBox(height: 20),
                          selectionCountry != "MNG"
                              ? Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: foriegnUser())
                              : const SizedBox(),
                          //#endregion

                          selectionCountry == "MNG"
                              ? Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: txtField2(cont.rdtxt,
                                      'Регистрийн дугаараа оруулна уу'),
                                )
                              : const SizedBox(),

                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: generalBtn(
                                CoreColor.mainPurple, Colors.white, 'илгээх',
                                () {
                              cont.documentFind(
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

  Object failedDialogy() {
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
                        InkWell(
                          onTap: () {
                            Get.offAll(() => const ContentHome());
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 40, right: 40),
                            decoration: BoxDecoration(
                                color: CoreColor.mainPurple,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: const Text(
                              "Нэвтрэх",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
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

  String selectionGender = "Эр";
  Widget foriegnUser() {
    return Column(
      children: [
        const Text(
          'Үндсэн мэдээлэл',
        ),
        spacerLine(),
        txtField2(cont.lastNameController, 'Нэр'),
        txtField2(cont.firstNameController, 'Овог'),
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
              setState(() {
                selectionGender = value.toString();
              });
            },
          ),
        ),
        datePicker('Төрсөн огноо', cont.birthday),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        const Text(
          'Паспортын мэдээлэл',
        ),
        spacerLine(),
        txtField2(cont.docNoController, 'Паспортын дугаар'),
        datePicker('Паспорт олгосон огноо', cont.givenDay),
        datePicker('Паспорт дуусах огноо', cont.expiredDay),
      ],
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
}
