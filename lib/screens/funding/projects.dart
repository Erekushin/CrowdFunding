import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/screens/funding/pay_info.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../global_players.dart';
import '../../helpers/backHelper.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/indicators.dart';
import '../../helpers/services.dart';
import '../../widget/combos/appbar_squeare.dart';
import '../../widget/combos/eachproject.dart';
import '../../widget/combos/pre_sidebar.dart';
import '../../widget/combos/sidebar.dart';
import '../dialogs/warning_dialogs.dart';
import 'singleProject.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final crowdlog = logger(Projects);

  @override
  void initState() {
    getTypeList();
    getProjectList();
    super.initState();
  }

  //#region helper funcs

  RxBool noProject = false.obs;
  RxBool loading = false.obs;
  RxBool noInternet = false.obs;
  RxBool error = false.obs;
  visibilitySwitch(ScreenModes mode) {
    switch (mode) {
      case ScreenModes.data:
        noProject.value = false;
        loading.value = false;
        noInternet.value = false;
        error.value = false;
        break;
      case ScreenModes.noProject:
        noProject.value = true;
        loading.value = false;
        noInternet.value = false;
        error.value = false;
        break;
      case ScreenModes.loading:
        noProject.value = false;
        loading.value = true;
        noInternet.value = false;
        error.value = false;
        break;
      case ScreenModes.noInternet:
        noProject.value = false;
        loading.value = false;
        noInternet.value = true;
        error.value = false;
        break;
      case ScreenModes.error:
        noProject.value = false;
        loading.value = false;
        noInternet.value = false;
        error.value = true;
        break;
      default:
    }
  }

  var all = {"id": "0", "name": "Бүгд", "created_date": "2022-12-06 19:00:44"};
  RxList typeList = [].obs;
  void getTypeList() async {
    await Services()
        .getRequest('${CoreUrl.crowdfund}category', true, '')
        .then((data) {
      var res = data.body;
      crowdlog.wtf(
          '---GET TYPE LIST---:TOKEN: ${GlobalVariables.token}.................returned data ${data.body.toString()}');
      if (data.statusCode == 200) {
        typeList.value = data.body['result']['items'];
        typeList.insert(0, all);
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
    });
  }

  RxList projectList = [].obs;
  void getProjectList() async {
    loading.value = true;
    await Services()
        .getRequest('${CoreUrl.crowdfund}crowdfund/confirmed', true, '')
        .then((data) {
      crowdlog.wtf(
          '---GET PROJECT LIST---:TOKEN: ${GlobalVariables.token}.................returned data ${data.body.toString()}');
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, 1, () {
        projectList.value = data.body['result']['items'];
        itemList4.value = data.body['result']['items'];
        if (projectList.isEmpty) {
          noProject.value = true;
        }
      }, () {
        visibilitySwitch(ScreenModes.noInternet);
      });
    });
    loading.value = false;
  }

  void searchProject() async {
    // await Services()
    //     .getRequest(
    //         '${CoreUrl.crowdfund}crowdfund/confirmed?search_text=${searchCont.text}&category_id=${selectionType != '0' ? selectionType : ''}',
    //         true,
    //         '')
    //     .then((data) {
    //   crowdlog.wtf(
    //       '---Search response---:TOKEN: ${GlobalVariables.token}.................returned data ${data.body.toString()}');
    //   GlobalPlayers.frontHelper.requestErrorSnackbar(data, 1, () {
    //     itemList4.value = data.body['result']['items'];
    //     if (projectList.isEmpty) {
    //       noProject.value = true;
    //     }
    //   }, () {
    //     visibilitySwitch(ScreenModes.noInternet);
    //   });
    // });
    // print(betweenLenth('1'));
    itemList.replaceRange(
        0,
        itemList.length,
        projectList.where((element) => element['name']
            .toLowerCase()
            .contains(searchCont.text.toLowerCase())));
    itemList4 = itemList;
  }

  //#endregion
  GlobalKey<ScaffoldState> menuSidebarKeyProjects = GlobalKey<ScaffoldState>();
  PageController pageCont = PageController();
  RxList itemList4 = [].obs;
  RxList itemList = [].obs;
  TextEditingController searchCont = TextEditingController();
  String selectionType = "0";
  @override
  Widget build(BuildContext context) {
    return fundingTop(
        context,
        null,
        1,
        'Projects',
        menuSidebarKeyProjects,
        Obx(() => Column(
              children: [
                Container(
                  //search
                  padding: const EdgeInsets.only(
                    left: 15,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(.5)),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: TextField(
                    controller: searchCont,
                    onChanged: (value) {},
                    style: GoogleFonts.sourceSansPro(
                        height: 2,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black54),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchProject();
                        },
                        icon: const Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(4),
                      hintText: 'search project',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(.5)),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: DropdownButton(
                    iconEnabledColor: CoreColor.mainPurple,
                    iconDisabledColor: CoreColor.mainPurple,
                    value: selectionType,
                    underline: const SizedBox(),
                    isExpanded: true,
                    hint: Text(
                      'Choose category',
                      style: GoogleFonts.sourceSansPro(
                          height: 2,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black54),
                    ),
                    items: typeList.map((value) {
                      return DropdownMenuItem(
                        value: value['id'],
                        child: Text(
                          value['name'],
                          style: GoogleFonts.sourceSansPro(
                              height: 2,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black54),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectionType = value.toString();
                      });
                      if (value == '0') {
                        itemList4 = projectList;
                        crowdlog.wtf(projectList.length);
                      } else {
                        itemList.replaceRange(
                            0,
                            itemList.length,
                            projectList.where((element) =>
                                element['category_id'] ==
                                int.parse(value.toString())));
                        itemList4 = itemList;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: itemList4.length,
                    itemBuilder: (c, projectIndex) {
                      int progress;
                      var item = itemList4[projectIndex];
                      int amount = item['amount'];
                      int balance = item['balance'];
                      progress = progressProcent(amount, balance).toInt();
                      return eachproject(item, progress, item['img_base64'],
                          () {
                        Get.to(() => SingleProject(
                              item: item,
                              proProgress: progress,
                              imgUrl: item['img_base64'],
                            ));
                      });
                    }),
              ],
            )));
  }
}

Widget fundingTop(BuildContext context, var item, int step, String title,
    GlobalKey<ScaffoldState> menuSidebarKey, Widget body) {
  return Scaffold(
    key: menuSidebarKey,
    endDrawer: GlobalVariables.userInfo['id'] == ""
        ? PreSidebar(
            menuAction: () {
              menuSidebarKey.currentState?.closeEndDrawer();
            },
          )
        : Sidebar(
            menuAction: () {
              menuSidebarKey.currentState?.closeEndDrawer();
            },
          ),
    appBar: AppbarSquare(
      height: GlobalVariables.gWidth * .26,
      leadingIcon: Icon(
        FontAwesomeIcons.bars,
        color: Colors.black,
        size: Sizes.iconSize,
      ),
      title: 'CrowdfundingMN',
      titleColor: Colors.black,
      menuAction: () {
        menuSidebarKey.currentState!.openEndDrawer();
      },
      color: Colors.white,
    ),
    body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: GlobalVariables.gWidth,
              child: Wrap(
                children: [
                  const Icon(
                    FontAwesomeIcons.house,
                    size: 15,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      switch (step) {
                        case 2:
                          Get.back();
                          break;
                        case 3:
                          Get.close(2);
                          break;
                        default:
                      }
                    },
                    child: Text(
                      '   Projects   ',
                      style: TextStyle(
                          color: step == 1
                              ? CoreColor.mainPurple
                              : Colors.grey.shade400,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(
                    FontAwesomeIcons.anglesRight,
                    size: 15,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () {
                      switch (step) {
                        case 1:
                          Get.snackbar('Анхаараарай',
                              'та хөрөнгө оруулах төсөлөө сонгоно уу?',
                              colorText: Colors.black,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              duration: const Duration(seconds: 1));
                          break;
                        case 3:
                          Get.back();
                          break;
                        default:
                      }
                    },
                    child: Text(
                      '   Single Project   ',
                      style: TextStyle(
                          color: step == 2
                              ? CoreColor.mainPurple
                              : Colors.grey.shade400,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(
                    FontAwesomeIcons.anglesRight,
                    size: 15,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () {
                      switch (step) {
                        case 1:
                          Get.snackbar('Анхаараарай',
                              'та хөрөнгө оруулах төсөлөө сонгоно уу?',
                              colorText: Colors.black,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              duration: const Duration(seconds: 1));
                          break;
                        case 2:
                          if (GlobalVariables.userInfo['id'] == "") {
                            signinReminder(context);
                          } else {
                            Get.to(() => PayInfo(
                                  item: item,
                                ));
                          }
                          break;
                        default:
                      }
                    },
                    child: Text(
                      '   Funding',
                      style: TextStyle(
                          color: step == 3
                              ? CoreColor.mainPurple
                              : Colors.grey.shade400,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            body
          ],
        )),
  );
}
