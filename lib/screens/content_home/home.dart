import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helpers/core_url.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/indicators.dart';
import '../../helpers/logging.dart';
import '../../services/get_service.dart';
import '../../widget/appbar_squeare.dart';
import '../../widget/eachproject.dart';
import '../../widget/sidebar.dart';

class ContentHome extends StatefulWidget {
  const ContentHome({super.key});

  @override
  State<ContentHome> createState() => _ContentHomeState();
}

class _ContentHomeState extends State<ContentHome> {
  final crowdlog = logger(_ContentHomeState);
  var scrollController = ScrollController(initialScrollOffset: 55);
  GlobalKey<ScaffoldState> menuSidebarKey = GlobalKey<ScaffoldState>();
  RxList projectList = [].obs;
  RxList typeList = [].obs;
  RxBool noProject = false.obs;
  RxBool loading = false.obs;
  RxBool noInternet = false.obs;
  RxBool error = false.obs;
  int chosenTap = 0;
  String option = '1';
  PageController pageCont = PageController();
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
      setState(() {
        scrollController.animateTo(55,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      });
    } catch (e) {
      crowdlog.wtf(
          '---GET PROJECT LIST---:TOKEN: ${GlobalVariables.gStorage.read("token")}.................returned data ${e.toString()}');
      setState(() {
        scrollController.animateTo(55,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      });
      loading.value = false;
    }
  }

  @override
  void initState() {
    getTypeList();
    getProjectList();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() async {
    setState(() {
      rotate = scrollController.offset;
    });
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      //reach bottom
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      //reach the top
      getProjectList();
    }
  }

  double rotate = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: menuSidebarKey,
      drawer: Sidebar(
        menuAction: () {
          menuSidebarKey.currentState?.closeDrawer();
        },
      ),
      appBar: AppbarSquare(
        height: GlobalVariables.gWidth * .25,
        leadingIcon: const Icon(
          FontAwesomeIcons.bars,
          color: Colors.white,
          size: 18,
        ),
        title: 'CrowdfundingMN',
        titleColor: Colors.white,
        menuAction: () {
          menuSidebarKey.currentState!.openDrawer();
        },
        color: CoreColor.mainGreen,
      ),
      body: Column(
        children: [
          SizedBox(
              height: GlobalVariables.gHeight * .066,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            chosenTap = 0;
                            pageCont.jumpToPage(0);
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            tabtext('Бүгд'),
                            chosenTap == 0
                                ? Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    height: 4,
                                    width: 100,
                                    color: CoreColor.mainGreen,
                                  )
                                : const SizedBox(
                                    width: 100,
                                  )
                          ],
                        )),
                    Obx(() => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: typeList.length,
                        itemBuilder: (c, i) {
                          var item = typeList[i];
                          return TextButton(
                              onPressed: () {
                                setState(() {
                                  chosenTap = int.parse(item['id']);
                                  pageCont.jumpToPage(int.parse(item['id']));
                                });
                              },
                              child: Column(
                                children: [
                                  tabtext(item['name']),
                                  chosenTap == int.parse(item['id'])
                                      ? Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          height: 4,
                                          width: 100,
                                          color: CoreColor.mainGreen,
                                        )
                                      : const SizedBox(
                                          width: 100,
                                        )
                                ],
                              ));
                        }))
                  ],
                ),
              )),
          SizedBox(
            height: GlobalVariables.gHeight * .8,
            child: PageView.builder(
              onPageChanged: (currentpageIndex) {
                setState(() {
                  crowdlog.wtf(chosenTap);
                  chosenTap = currentpageIndex;
                  crowdlog.wtf(chosenTap);
                });
              },
              controller: pageCont,
              itemCount: typeList.length + 1,
              itemBuilder: (c, pageIndex) {
                RxList itemList = [].obs;
                for (int a = 0; a < projectList.length; a++) {
                  if (projectList[a]['category_id'] == pageIndex) {
                    itemList.add(projectList[a]);
                  }
                }
                return Obx(() => Stack(
                      children: [
                        SizedBox(
                          height: GlobalVariables.gHeight * .8,
                          child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              controller:
                                  pageIndex == 0 ? scrollController : null,
                              child: Column(
                                children: [
                                  Transform.rotate(
                                    angle: 3.14 / (rotate + 1) * 2,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle),
                                      width: 50,
                                      height: 50,
                                      child: const Icon(
                                        FontAwesomeIcons.rotateLeft,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: pageIndex == 0
                                          ? projectList.length
                                          : itemList.length,
                                      itemBuilder: (c, projectIndex) {
                                        int progress;
                                        var item = pageIndex == 0
                                            ? projectList[projectIndex]
                                            : itemList[projectIndex];
                                        int amount = item['amount'];
                                        int balance = item['balance'];
                                        progress =
                                            progressProcent(amount, balance)
                                                .toInt();
                                        return eachproject(item, progress);
                                      }),
                                ],
                              )),
                        ),
                        Visibility(
                            visible: noProject.value,
                            child: Image.asset('assets/images/empty_box.jpg')),
                        Visibility(
                            visible: loading.value ? true : false,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: const CircularProgressIndicator()),
                            )),
                        Visibility(
                            visible: noInternet.value,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child:
                                  Image.asset('assets/images/noInternet.png'),
                            ))
                      ],
                    ));
              },
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
}
