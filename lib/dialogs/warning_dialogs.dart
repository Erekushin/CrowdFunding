import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../global_players.dart';
import '../helpers/gvariables.dart';
import '../style/color.dart';
import '../widget/fundamental/btn.dart';
import '../screens/entrance/login.dart';
import '../screens/entrance/register_recover.dart';

Object signinReminder(BuildContext context) {
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
                                Navigator.pop(context);
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
                            'Та сонгосон төсөлдөө хөрөнгө оруулахын тулд эхлээд нэвтэрч орсон байх хэрэгтэй.',
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
                                'Хэрэв бүртгэл үүсгэж амжиагүй бол sign up товч дээр дарна уу.',
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
                            margin: const EdgeInsets.all(30),
                            child: Column(
                              children: [
                                generalBtn(CoreColor.backlightGrey,
                                    CoreColor.mainPurple, 'sign in', () {
                                  Get.to(() => const LoginScreen());
                                }),
                                const SizedBox(
                                  height: 20,
                                ),
                                generalBtn(CoreColor.mainPurple, Colors.white,
                                    'sign up', () {
                                  Get.to(() => const Register_Recover(
                                        title: 'Нууц үг сэргээх',
                                      ));
                                }),
                              ],
                            ))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      });
    },
  );
}
