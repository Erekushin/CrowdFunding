import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../global_players.dart';
import '../../helpers/backHelper.dart';
import '../../helpers/core_url.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/indicators.dart';
import '../../helpers/services.dart';
import '../../widget/combos/appbar_squeare.dart';
import '../../widget/combos/eachproject.dart';
import '../../widget/combos/helper_widgets.dart';
import '../../widget/combos/sidebar.dart';
import 'content.dart';

class ContentHome extends StatefulWidget {
  const ContentHome({super.key});

  @override
  State<ContentHome> createState() => _ContentHomeState();
}

class _ContentHomeState extends State<ContentHome> {
  final crowdlog = logger(ContentHome);

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

  RxList typeList = [].obs;
  void getTypeList() async {
    await Services()
        .getRequest('${CoreUrl.crowdfund}category', true, '')
        .then((data) {
      var res = data.body;
      crowdlog.wtf(
          '---GET TYPE LIST---:TOKEN: ${GlobalVariables.gStorage.read("token")}.................returned data ${data.body.toString()}');
      if (data.statusCode == 200) {
        typeList.value = data.body['result']['items'];
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
    try {
      await Services()
          .getRequest('${CoreUrl.crowdfund}crowdfund/confirmed', true, '')
          .then((data) {
        // Navigator.of(Get.overlayContext!).pop();
        var res = data.body;
        crowdlog.wtf(
            '---GET PROJECT LIST---:TOKEN: ${GlobalVariables.gStorage.read("token")}.................returned data ${data.body.toString()}');
        switch (data.statusCode) {
          case 200:
            projectList.value = data.body['result']['items'];
            if (projectList.isEmpty) {
              noProject.value = true;
            }
            break;
          case 400:
            visibilitySwitch(ScreenModes.noInternet);
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
      loading.value = false;
    } catch (e) {
      crowdlog.wtf(
          '---GET PROJECT LIST---:TOKEN: ${GlobalVariables.gStorage.read("token")}.................returned data ${e.toString()}');
      loading.value = false;
    }
  }

  //#endregion
  GlobalKey<ScaffoldState> menuSidebarKey = GlobalKey<ScaffoldState>();
  PageController pageCont = PageController();
  RxList itemList4 = [].obs;
  TextEditingController searchCont = TextEditingController();
  String selectionType = "1";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: menuSidebarKey,
        endDrawer: Sidebar(
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
        body: Obx(() => Stack(
              children: [
                SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.house,
                              size: 15,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              ' Home  ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              FontAwesomeIcons.anglesRight,
                              size: 15,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Projects',
                              style: TextStyle(
                                  color: CoreColor.mainPurple,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Projects',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          //search
                          padding: const EdgeInsets.only(
                            left: 15,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(.5)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: TextField(
                            controller: searchCont,
                            onChanged: (value) {},
                            style: GoogleFonts.sourceSansPro(
                                height: 2,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black54),
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                color: Colors.grey,
                                size: 15,
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
                              border: Border.all(
                                  color: Colors.grey.withOpacity(.5)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
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
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: projectList.length,
                            itemBuilder: (c, projectIndex) {
                              int progress;
                              var item = projectList[projectIndex];
                              int amount = item['amount'];
                              int balance = item['balance'];
                              progress =
                                  progressProcent(amount, balance).toInt();
                              return eachproject(
                                  item, progress, item['img_base64'], () {
                                Get.to(() => Content(
                                      item: item,
                                      proProgress: progress,
                                      imgUrl: item['img_base64'],
                                    ));
                              });
                            }),
                      ],
                    )),
                screenModes(ScreenModes.noProject, noProject,
                    'assets/images/empty_box.jpg'),
                screenModes(ScreenModes.loading, loading, ''),
                screenModes(ScreenModes.noInternet, noInternet,
                    'assets/images/noInternet.png')
              ],
            )));
  }
}
