import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';

import '../../helpers/backHelper.dart';
import '../../helpers/core_url.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/services.dart';
import '../../widget/appbar_squeare.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarSquare(
        height: GlobalVariables.gHeight * .12,
        leadingIcon: const Icon(
          FontAwesomeIcons.leftLong,
          color: Colors.black,
          size: 18,
        ),
        menuAction: () {
          Get.back();
        },
        titleColor: Colors.black,
        color: CoreColor.backlightGrey,
        title: 'Төлбөрийн мэдээлэл',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                SizedBox(
                  height: 20,
                ),
                Text('Хэтэвчний мэдээлэл'),
                SizedBox(
                  height: 30,
                ),
                rowofinfo(
                    'Үлдэгдэл', '${GlobalVariables.accountBalance.value}₮'),
                rowofinfo('Хөрөнгө оруулалт', '1 Сая₮'),
                rowofinfo('Боломжит үлдэгдэл', '1 Сая₮'),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text('Хөрөнгө оруулалтын хэмжээ (10,0000 төг)'),
              SizedBox(
                height: 50,
              ),
              Text(
                '${fundingValue * 10},000',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
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
                        color: CoreColor.mainGreen,
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
                    color: CoreColor.mainGreen,
                  ),
                  Container(
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
                            color: CoreColor.mainGreen,
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
                    color: CoreColor.mainGreen,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: const Text(
                  'хөрөнгө оруулах',
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
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
      "user_id": int.parse(GlobalVariables.id),
      "amount": fundingValue * 1000,
    };
    try {
      await Services()
          .postRequest(json.encode(bodyData),
              '${CoreUrl.crowdfund}crowdfund_user', true, '')
          .then((data) {
        // Navigator.of(Get.overlayContext!).pop();
        var res = data.body;
        crowdlog.wtf(
            '---fund to project---:body: $bodyData.................returned data ${data.body.toString()}');
        switch (data.statusCode) {
          case 200:
            Get.snackbar(
              '',
              'Төсөлд амжилттай хөрөнгө орууллаа. Таньд амжилт хүсье',
              backgroundColor: Colors.white60,
              colorText: Colors.black,
            );
            break;
          case 400:
            break;
          default:
            Get.snackbar(
              'warning_tr'.translationWord(),
              res['message'].toString(),
              backgroundColor: Colors.white60,
              colorText: Colors.black,
            );
        }
      });
    } catch (e) {
      crowdlog.wtf(
          '---GET PROJECT LIST---:TOKEN: ${GlobalVariables.gStorage.read("token")}.................returned data ${e.toString()}');
    }
  }
}
