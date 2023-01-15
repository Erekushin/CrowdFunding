import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/screens/content_home/pay_info.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';

import '../../global_players.dart';
import '../../helpers/core_url.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/working_dates.dart';

// ignore: must_be_immutable
class Content extends StatefulWidget {
  Content(
      {super.key,
      required this.item,
      required this.proProgress,
      required this.imgUrl});
  var item;
  int proProgress;
  String imgUrl;
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
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          NetworkImage('${CoreUrl.fileServer}${widget.imgUrl}'),
                      fit: BoxFit.cover)),
            ),
            Row(
              children: [
                Expanded(
                  flex: widget.proProgress,
                  child: Container(
                    height: 5,
                    color: const Color(0xFF00AB44),
                  ),
                ),
                Expanded(
                  flex: (10 - widget.proProgress),
                  child: Container(
                    height: 5,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      contentInfo(
                          widget.item['balance'].toString().ammountCorrection(),
                          'pledged of ${widget.item['amount'].toString().ammountCorrection()} goal'),
                      const SizedBox(
                        width: 30,
                      ),
                      contentInfo(
                          widget.item['user_cnt'].toString(), 'backers'),
                      const SizedBox(
                        width: 30,
                      ),
                      contentInfo(
                          countRemainingDays(
                              widget.item['end_date'].toString()),
                          'days to go'),
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
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(45)),
                            image: DecorationImage(
                                image: NetworkImage(
                                    '${CoreUrl.fileServer}${widget.imgUrl}'),
                                fit: BoxFit.cover)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item['org_name'].toString(),
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              infoTxtStyle('First created'),
                              const SizedBox(
                                width: 20,
                              ),
                              infoTxtStyle(
                                  widget.item['start_date'].toString()),
                            ],
                          ),
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
                        decoration: BoxDecoration(
                            color: CoreColor.mainPurple,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.item['name'].toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.item['introduction_text'].toString(),
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '${CoreUrl.fileServer}${widget.imgUrl}'),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.item['description'].toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 60,
                          )
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
                    Get.to(() => PayInfo(
                          item: widget.item,
                        ));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: 220,
                    height: 50,
                    decoration: BoxDecoration(
                        color: CoreColor.mainPurple,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
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
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.2),
                        shape: BoxShape.circle),
                    child: Icon(
                      FontAwesomeIcons.chevronLeft,
                      color: Colors.white,
                      size: Sizes.iconSize,
                    ),
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
              color: CoreColor.mainPurple),
        ),
        infoTxtStyle(blackOne)
      ],
    );
  }

  Widget infoTxtStyle(String txt) {
    return Text(
      txt,
      style: const TextStyle(fontSize: 8),
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
