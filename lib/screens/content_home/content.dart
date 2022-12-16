import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/screens/content_home/pay_info.dart';
import 'package:get/get.dart';

import '../../helpers/gvariables.dart';

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://i.pinimg.com/564x/66/1e/3c/661e3c81c896137ea8b88f54dfebf55c.jpg'),
                      fit: BoxFit.cover)),
            ),
            Container(
              height: 8,
              color: const Color(0xFF00AB44),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      contentInfo('150,450₮', 'pledged of 1,000,000₮ goal'),
                      const SizedBox(
                        width: 30,
                      ),
                      contentInfo('17', 'backers'),
                      const SizedBox(
                        width: 30,
                      ),
                      contentInfo('27', 'days to go'),
                    ],
                  ),
                  spacerBig(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://i.pinimg.com/564x/66/1e/3c/661e3c81c896137ea8b88f54dfebf55c.jpg'),
                                fit: BoxFit.cover)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'OKAMOTO Tomohiro',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          infoTxtStyle('First created'),
                          Row(
                            children: [
                              infoTxtStyle('An engineer.'),
                              const SizedBox(
                                width: 20,
                              ),
                              infoTxtStyle('okamoto247@gmail.com'),
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                            color: Color(0xFF00AB44),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        width: 100,
                        height: 30,
                        child: const Center(
                          child: Text(
                            'Contact',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  spacerBig(),
                  SizedBox(
                    height: GlobalVariables.gHeight * .54,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Hicarix Badge : LED Bulletin Board using B&W technology',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'An elegant LED badge that draws images using B&W technology from a phone screen. Express your creativity with this badge, made in Japan',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 200,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://i.pinimg.com/564x/66/1e/3c/661e3c81c896137ea8b88f54dfebf55c.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'The Hicarix® badge is an LED badge that looks like an electric bulletin board that can display a custom image you created in the Hicarix® App, a dedicated smartphone application.The Hicarix Badge is special in that it does NOT wireless communication, such as Wi-Fi or Bluetooth. Changing the display of the badge uses technology that reads the blinks from your smartphone screen, similar to Morse code.Three brightness sensors on the back of the device read the black and white, or bright or dark, of the smartphones screen.This rewrite method is the result of my search for a small, more affordable, and easy method; it is not as fast as Wi-Fi or Bluetooth, and it is subject to rewrite errors. Perhaps it may seem old-fashioned. But those who have used it have found the rewriting experience very positive.However, due to the shortage of semiconductors, I have not been able to manufacture or sell this product for a long time.With your support I will make the Hicarix Badge new and improved. And I will redesign with an enclosed and functional backing."Hicarix" is a play on the Japanese word Hikari (meaning "light"), which is derived from the idea of communicating and displaying light with light.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: GlobalVariables.gWidth,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.grey.withOpacity(0.7)
                        ]),
                  ),
                )
              ],
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => const PayInfo());
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: 220,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Color(0xFF00AB44),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: const Center(
                      child: Text(
                        'Хөрөнгө оруулах',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    FontAwesomeIcons.chevronLeft,
                    color: Colors.white,
                    size: 18,
                  ),
                )),
          ),
        )
      ],
    ));
  }

  Widget contentInfo(String greenOne, String blackOne) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greenOne,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00AB44)),
        ),
        infoTxtStyle(blackOne)
      ],
    );
  }

  Widget infoTxtStyle(String txt) {
    return Text(
      txt,
      style: TextStyle(fontSize: 8),
    );
  }

  Widget spacerBig() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      height: 1,
      color: Colors.black45,
    );
  }
}
