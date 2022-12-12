import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../screens/home/wallet/wallet_screen.dart';

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
                Expanded(
                  flex: 3,
                  child: Container(
                    color: const Color(0xFF00AB44),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            widget.menuAction();
                          },
                          icon: const Icon(
                            FontAwesomeIcons.bars,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
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
                        Get.to(() => const WalletScreen());
                      }),
                      menuComponent(context, FontAwesomeIcons.solidBell,
                          'Хөрөнгө оруулалт', () {}),
                      menuComponent(context, FontAwesomeIcons.peopleGroup,
                          'Тохиргоо', () {}),
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
                        onTap: () {},
                        child: Text('Гарах'),
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
                color: const Color(0xff465C94),
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