import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';

import '../../helpers/core_url.dart';
import '../../helpers/indicators.dart';
import '../../helpers/logging.dart';
import '../../services/get_service.dart';
import '../../widget/appbar_squeare.dart';
import '../../widget/eachproject.dart';
import '../../widget/helper_widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final crowdlog = logger(_ProfileState);
  var scrollController = ScrollController(initialScrollOffset: 55);
  RxList myFundedProjects = [].obs;

  //#region........helper functions.....

  double rotate = 0;
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
      getMyProjects();
    }
  }

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

  getMyProjects() async {
    visibilitySwitch(ScreenModes.loading);
    try {
      await Services()
          .getRequest('${CoreUrl.crowdfund}crowdfund_user/crowdfund', true, '')
          .then((data) {
        // Navigator.of(Get.overlayContext!).pop();
        var res = data.body;
        // crowdlog.wtf(
        //     '---GET MY PROJECT LIST---:TOKEN: ${GlobalVariables.gStorage.read("token")}.................returned data ${data.body.toString()}');
        switch (data.statusCode) {
          case 200:
            myFundedProjects.value = data.body['result']['items'];
            if (myFundedProjects.isEmpty) {
              visibilitySwitch(ScreenModes.noProject);
            }
            break;
          case 444:
            visibilitySwitch(ScreenModes.noInternet);
            Get.snackbar(
              'warning_tr'.translationWord(),
              res['message'].toString(),
              backgroundColor: Colors.white60,
              colorText: Colors.black,
            );
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
      Get.snackbar(
        'warning_tr'.translationWord(),
        e.toString(),
        backgroundColor: Colors.white60,
        colorText: Colors.black,
      );
      visibilitySwitch(ScreenModes.loading);
      setState(() {
        scrollController.animateTo(55,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      });
    }
  }

  //#endregion......

  @override
  void initState() {
    getMyProjects();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarSquare(
          height: GlobalVariables.gWidth * .4,
          leadingIcon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white,
            size: 18,
          ),
          menuAction: () {
            Get.back();
          },
          titleColor: Colors.white,
          color: CoreColor.mainGreen,
          title: '',
        ),
        body: Stack(
          children: [
            Container(
              height: GlobalVariables.gHeight * .5,
              width: GlobalVariables.gWidth,
              color: CoreColor.mainGreen,
              child: Column(children: [
                CircleAvatar(
                    backgroundColor: CoreColor.backlightGrey,
                    backgroundImage: const NetworkImage(
                        'https://i.pinimg.com/564x/66/1e/3c/661e3c81c896137ea8b88f54dfebf55c.jpg'),
                    radius: 80),
                const SizedBox(height: 10),
                const Text(
                  'Mandah',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  height: GlobalVariables.gHeight * .2,
                  width: GlobalVariables.gWidth * .8,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rowProInfo('хөрөнгө оруулалт', '4'),
                      rowProInfo('мөнгөн дүн', '150000000'),
                      rowProInfo('миний төслүүд', '2'),
                    ],
                  ),
                )
              ]),
            ),
            Obx(
              () => SizedBox(
                height: GlobalVariables.gHeight,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: scrollController,
                  child: Column(children: [
                    Transform.rotate(
                      angle: 3.14 / (rotate + 1) * 2,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                        width: 50,
                        height: 50,
                        child: const Icon(
                          FontAwesomeIcons.rotateLeft,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: GlobalVariables.gHeight * .5,
                    ),
                    Container(
                      color: Colors.white,
                      height: GlobalVariables.gHeight * .6,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Text(
                            'хөрөнгө оруулсан төслүүд',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            height: 3,
                            width: GlobalVariables.gWidth - 20,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: GlobalVariables.gHeight * .5,
                            child: Stack(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: myFundedProjects.length,
                                    itemBuilder: (c, projectIndex) {
                                      int progress;
                                      var item = myFundedProjects[projectIndex];
                                      int amount = item['amount'];
                                      int balance = item['balance'];
                                      progress =
                                          progressProcent(amount, balance)
                                              .toInt();
                                      return eachproject(
                                          item, progress, item['img_base64']);
                                    }),
                                screenModes(ScreenModes.noProject, noProject,
                                    'assets/images/empty_box.jpg'),
                                screenModes(ScreenModes.loading, loading, ''),
                                screenModes(ScreenModes.noInternet, noInternet,
                                    'assets/images/noInternet.png')
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            )
          ],
        ));
  }

  Widget rowProInfo(String title, String value) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500))
        ],
      ),
    );
  }
}
