import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/global_players.dart';
import 'package:gerege_app_v2/screens/funding/projects.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';

import '../../helpers/backHelper.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/services.dart';

// ignore: must_be_immutable
class PayInfo extends StatefulWidget {
  PayInfo({super.key, required this.item});
  var item;
  @override
  State<PayInfo> createState() => _PayInfoState();
}

class _PayInfoState extends State<PayInfo> {
  final crowdlog = logger(_PayInfoState);
  EdgeInsetsGeometry containerPadding =
      const EdgeInsets.only(left: 30, right: 30);
  int fundingValue = 1;
  GlobalKey<ScaffoldState> menuSidebarKeyPayment = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return fundingTop(
        context,
        widget.item,
        3,
        'Funding Detail',
        menuSidebarKeyPayment,
        Column(
          children: [
            Container(
              padding: containerPadding,
              child: rowofinfo('Ашигийн тооцоолол', '2 Сая₮'),
            ),
            Container(
              padding: containerPadding,
              color: CoreColor.backlightGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Хэтэвчний мэдээлэл'),
                  const SizedBox(
                    height: 30,
                  ),
                  rowofinfo(
                      'Үлдэгдэл', '${GlobalVariables.accountBalance.value}₮'),
                  rowofinfo('Хөрөнгө оруулалт', '1 Сая₮'),
                  rowofinfo('Боломжит үлдэгдэл', '1 Сая₮'),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Text('Хөрөнгө оруулалтын хэмжээ (10,0000 төг)'),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  '${fundingValue * 10},000',
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (fundingValue > 1) {
                            --fundingValue;
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                          color: CoreColor.backlightGrey,
                        ),
                        width: 50,
                        height: 50,
                        child: const Icon(FontAwesomeIcons.minus),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          setState(() {
                            ++fundingValue;
                          });
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          color: CoreColor.mainPurple,
                        ),
                        width: 50,
                        height: 50,
                        child: const Icon(
                          FontAwesomeIcons.plus,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: CoreColor.backlightGrey,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      FontAwesomeIcons.storeSlash,
                      color: CoreColor.mainPurple,
                    ),
                    SizedBox(
                      width: GlobalVariables.gWidth * .4,
                      child: const Text(
                        'Crowfunding is not store. it is way to bring creative projects to life',
                        style: TextStyle(fontSize: 11),
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'learn more',
                          style: TextStyle(
                              color: CoreColor.mainPurple,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )),
            InkWell(
                onTap: () {
                  fundToProject();
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 30, right: 30),
                  decoration: BoxDecoration(
                      color: CoreColor.mainPurple,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: const Text(
                    'хөрөнгө оруулах',
                    style: TextStyle(color: Colors.white),
                  ),
                ))
          ],
        ));
  }

  Widget rowofinfo(String info1, String info2) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(info1), Text(info2)],
      ),
    );
  }

  void fundToProject() async {
    var bodyData = {
      "fund_id": int.parse(widget.item['id']),
      "user_id": int.parse(GlobalVariables.userInfo['id']),
      "amount": fundingValue * 10000,
    };
    await Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.crowdfund}crowdfund_user', true, '')
        .then((data) {
      // Navigator.of(Get.overlayContext!).pop();
      var res = data.body;
      crowdlog.wtf(
          '---fund to project---:body: $bodyData.................returned data ${data.body.toString()}');
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, 1, () {
        Get.snackbar(
          '',
          'Төсөлд амжилттай хөрөнгө орууллаа. Таньд амжилт хүсье',
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
      }, () {});
    });
  }
}
