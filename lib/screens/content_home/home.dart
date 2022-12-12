import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helpers/core_url.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/logging.dart';
import '../../services/get_service.dart';
import '../../widget/appbar_squeare.dart';
import '../../widget/sidebar.dart';
import 'content.dart';

class ContentHome extends StatefulWidget {
  const ContentHome({super.key});

  @override
  State<ContentHome> createState() => _ContentHomeState();
}

class _ContentHomeState extends State<ContentHome> {
  final crowdlog = logger(_ContentHomeState);
  GlobalKey<ScaffoldState> menuSidebarKey = GlobalKey<ScaffoldState>();
  RxList projectList = [].obs;
  String option = '1';
  List<DropdownMenuItem<String>> dropitems(List<dynamic> optionList) {
    return optionList.map((item) {
      return DropdownMenuItem(
        value: item.toString(),
        child: Text(
          item.toString(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        onTap: () {},
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getProjectList();
  }

  void getProjectList() async {
    await Services()
        .getRequest('${CoreUrl.crowdfund}crowdfund', true, '')
        .then((data) {
      // Navigator.of(Get.overlayContext!).pop();
      var res = data.body;
      crowdlog.wtf(
          '---GET PROJECT LIST---:TOKEN: ${GlobalVariables.gStorage.read("token")}.................returned data ${data.body.toString()}');
      if (data.statusCode == 200) {
        projectList.value = data.body['result']['items'];
      } else {
        print("wtf");
        print(res);
        Get.snackbar(
          'warning_tr'.translationWord(),
          res['message'].toString(),
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
      }
      // print(data.body['authorization']['token']);
      // log(data.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('project list item count ${projectList.length}');
    return Scaffold(
      key: menuSidebarKey,
      drawer: Sidebar(
        menuAction: () {
          menuSidebarKey.currentState?.closeDrawer();
        },
      ),
      appBar: AppbarSquare(
        title: 'CrowdfundingMN',
        menuAction: () {
          menuSidebarKey.currentState!.openDrawer();
          print(menuSidebarKey.currentState.toString());
          print('object');
        },
        color: const Color(0xFF00AB44),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 5, top: 2, bottom: 2),
                      width: 150,
                      margin: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: DropdownButton<String>(
                          hint: Text('ds'),
                          value: option,
                          onChanged: (String? newValue) {
                            setState(() {
                              option = newValue.toString();
                            });
                          },
                          underline: const SizedBox(),
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(5),
                          items: dropitems(['dsds', '1', 'sdd']))))),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () {}, child: tabtext('All')),
                  TextButton(onPressed: () {}, child: tabtext('Popular')),
                  TextButton(onPressed: () {}, child: tabtext('Newest')),
                  TextButton(onPressed: () {}, child: tabtext('Ending soon')),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 15,
            child: PageView(
              children: [
                ListView.builder(
                    itemCount: projectList.length,
                    itemBuilder: (c, i) {
                      var item = projectList[i];
                      return InkWell(
                        onTap: () {
                          Get.to(() => const Content());
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            children: [
                              Container(
                                height: 150,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'https://i.pinimg.com/564x/66/1e/3c/661e3c81c896137ea8b88f54dfebf55c.jpg'),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                height: 8,
                                color: const Color(0xFF00AB44),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                item['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                item['description'],
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  greenInfo(item['amount'].toString()),
                                  littleSpacer(),
                                  greenInfo('32 donations'),
                                  littleSpacer(),
                                  greenInfo('18 хоног үлдсэн'),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                Container(
                  color: Colors.grey,
                ),
                Container(
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabtext(String txt) {
    return Text(
      txt,
      maxLines: 4,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.sourceSansPro(
          height: 1,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.black54),
    );
  }

  Widget greenInfo(String txt) {
    return Text(
      txt,
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: Color(0xFF00AB44), fontSize: 11),
    );
  }

  Widget littleSpacer() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      height: 10,
      width: 1,
      color: Colors.black,
    );
  }
}
