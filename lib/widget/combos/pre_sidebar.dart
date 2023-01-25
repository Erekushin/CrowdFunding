import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CrowdFund/style/color.dart';
import 'package:get/get.dart';

import '../../screens/entrance/login.dart';
import '../../screens/entrance/register_recover.dart';
import '../fundamental/accessory.dart';
import '../fundamental/btn.dart';

class PreSidebar extends StatefulWidget {
  const PreSidebar({super.key, required this.menuAction});
  final Function menuAction;
  @override
  State<PreSidebar> createState() => _PreSidebarState();
}

class _PreSidebarState extends State<PreSidebar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                widget.menuAction();
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.15),
                      Colors.black.withOpacity(.15),
                    ],
                  ),
                ),
              ),
            )),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  height: 50,
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 5, bottom: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'menu',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                    widget.menuAction();
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.x,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ),
                              ]),
                        ),
                        littleSpacer(),
                        const SizedBox(
                          height: 40,
                        ),
                        generalBtn(CoreColor.backlightGrey,
                            CoreColor.mainPurple, 'sign in', () {
                          Get.to(() => const LoginScreen());
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        generalBtn(
                            CoreColor.mainPurple, Colors.white, 'sign up', () {
                          Get.to(() => const Register_Recover(
                                title: 'Нууц үг сэргээх',
                              ));
                        }),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget menuComponent(
      BuildContext context, IconData icon, String txt, Function func) {
    return InkWell(
      onTap: () {
        func();
      },
      borderRadius: BorderRadius.circular(15),
      splashColor: Colors.grey.withOpacity(0.01),
      child: ClipRRect(
        child: Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10),
          margin: const EdgeInsets.only(left: 30, right: 30),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade400, width: 0.5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: CoreColor.mainPurple,
                size: 18,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(txt)
            ],
          ),
        ),
      ),
    );
  }
}
