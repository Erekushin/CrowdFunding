import 'package:flutter/material.dart';
import 'package:CrowdFund/screens/funding/pay_info.dart';
import 'package:CrowdFund/style/color.dart';
import 'package:get/get.dart';

import '../../global_players.dart';
import '../../helpers/gvariables.dart';
import '../../dialogs/warning_dialogs.dart';
import 'projects.dart';

// ignore: must_be_immutable
class SingleProject extends StatefulWidget {
  SingleProject(
      {super.key,
      required this.item,
      required this.proProgress,
      required this.imgUrl});
  var item;
  int proProgress;
  String imgUrl;
  @override
  State<SingleProject> createState() => _SingleProjectState();
}

class _SingleProjectState extends State<SingleProject> {
  GlobalKey<ScaffoldState> menuSidebarKeySingle = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return fundingTop(
        context,
        widget.item,
        2,
        widget.item['name'].toString(),
        menuSidebarKeySingle,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('data'),
                InkWell(
                  onTap: () {
                    if (GlobalVariables.userInfo['id'] == "") {
                      signinReminder(context);
                    } else {
                      Get.to(() => PayInfo(
                            item: widget.item,
                          ));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: CoreColor.mainPurple,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: const Center(
                      child: Text(
                        'Хөрөнгө оруулах',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                      image:
                          NetworkImage('${CoreUrl.fileServer}${widget.imgUrl}'),
                      fit: BoxFit.cover)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: const Text(
                'About',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              widget.item['introduction_text'].toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black.withOpacity(.5)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: const Text(
                'Challenge',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              widget.item['description'].toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black.withOpacity(.5)),
            ),
          ],
        ));
  }
}
