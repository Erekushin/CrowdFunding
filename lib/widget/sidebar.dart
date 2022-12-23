import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';

import '../screens/home/wallet/wallet_screen.dart';
import '../screens/login/main_login/login_screen.dart';
import '../screens/profile/profile.dart';
import '../screens/setting/settings.dart';
import '../screens/wallet/wallet_main.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key, required this.menuAction});
  final Function menuAction;
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  color: CoreColor.mainGreen,
                  height: 50,
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: CoreColor.mainGreen,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => const Profile());
                              },
                              child: CircleAvatar(
                                backgroundColor: CoreColor.backlightGrey,
                                backgroundImage: const NetworkImage(
                                    'https://i.pinimg.com/564x/66/1e/3c/661e3c81c896137ea8b88f54dfebf55c.jpg'),
                                radius: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Mandah',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            widget.menuAction();
                          },
                          icon: const Icon(
                            FontAwesomeIcons.bars,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      menuComponent(
                          context, FontAwesomeIcons.magnifyingGlass, 'Хэтэвч',
                          () {
                        // Get.to(() => const WalletScreen());
                        Get.to(() => const WalletMain());
                      }),
                      menuComponent(context, FontAwesomeIcons.magnifyingGlass,
                          'Хэтэвч huuchin', () {
                        Get.to(() => const WalletScreen());
                      }),
                      menuComponent(context, FontAwesomeIcons.solidBell,
                          'Хөрөнгө оруулалт', () {}),
                      menuComponent(
                          context, FontAwesomeIcons.peopleGroup, 'Тохиргоо',
                          () {
                        Get.to(() => const Settings());
                      }),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        FontAwesomeIcons.doorOpen,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        splashColor: Colors.grey.withOpacity(0.01),
                        onTap: () {
                          Get.offAll(() => const LoginScreen());
                        },
                        child: const Text('Гарах'),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ),
                const Expanded(child: SizedBox())
              ],
            ),
          ),
        ),
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
            ))
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
                color: CoreColor.mainGreen,
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
