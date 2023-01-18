import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/global_players.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';

import '../../screens/entrance/login.dart';
import '../../screens/home/landing_home.dart';
import '../../screens/profile/profile.dart';
import '../../screens/wallet/wallet_main.dart';
import '../fundamental/accessory.dart';
import 'dart:math';

class MyCustomPainter extends CustomPainter {
  final double animationValue;

  MyCustomPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (int value = 3; value >= 0; value--) {
      circle(canvas, Rect.fromLTRB(0, 0, size.width, size.height),
          value + animationValue);
    }
  }

  void circle(Canvas canvas, Rect rect, double value) {
    Paint paint = Paint()
      ..color =
          CoreColor.mainPurple.withOpacity((1 - (value / 4)).clamp(.0, 1));

    canvas.drawCircle(rect.center,
        sqrt((rect.width * .5 * rect.width * .5) * value / 4), paint);
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return true;
  }
}

class Sidebar extends StatefulWidget {
  const Sidebar({super.key, required this.menuAction});
  final Function menuAction;
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        } else if (status == AnimationStatus.completed) {
          _animationController.repeat();
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                        InkWell(
                            onTap: () {
                              Get.to(() => const Profile());
                            },
                            child: SizedBox(
                              width: 150,
                              child: Stack(
                                children: [
                                  CustomPaint(
                                    painter: MyCustomPainter(_animation.value),
                                    child: Container(
                                      margin: EdgeInsets.all(40),
                                    ),
                                  ),
                                  Center(
                                    child: CircleAvatar(
                                      backgroundColor: CoreColor.backlightGrey,
                                      backgroundImage: const NetworkImage(
                                          'https://i.pinimg.com/564x/66/1e/3c/661e3c81c896137ea8b88f54dfebf55c.jpg'),
                                      radius: 40,
                                    ),
                                  )
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: 140,
                          height: 20,
                          child: Center(
                            child: Text(
                              GlobalVariables.firstName,
                              softWrap: true,
                              maxLines: 3,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: GlobalVariables.firstName.length > 8
                                      ? 18
                                      : 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                        Get.to(() => const WalletMain());
                      }),
                      menuComponent(
                          context, FontAwesomeIcons.user, 'Өөр бүртгэл ашиглах',
                          () {
                        Get.offAll(() => const LoginScreen());
                      }),
                      menuComponent(context, FontAwesomeIcons.doorOpen, 'Гарах',
                          () {
                        GlobalPlayers.workingWithFile.cleanUserInfo();
                        Get.offAll(() => const LandingHome());
                      }),
                    ],
                  ),
                )
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
              SizedBox(width: 100, child: Text(txt))
            ],
          ),
        ),
      ),
    );
  }
}
