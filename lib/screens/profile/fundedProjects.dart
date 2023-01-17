import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/screens/profile/profile.dart';
import 'package:get/get.dart';

import '../../helpers/backHelper.dart';
import '../../helpers/core_url.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/indicators.dart';
import '../../helpers/services.dart';
import '../../widget/combos/eachproject.dart';
import '../../widget/combos/helper_widgets.dart';
import '../content_home/content.dart';

class FundedProjects extends StatefulWidget {
  const FundedProjects({super.key});

  @override
  State<FundedProjects> createState() => _FundedProjectsState();
}

class _FundedProjectsState extends State<FundedProjects> {
  final crowdlog = logger(FundedProjects);
  int proBtnInx = Get.arguments as int;

  @override
  void initState() {
    getMyProjects();
    super.initState();
  }

  RxList myFundedProjects = [].obs;
  getMyProjects() async {
    visibilitySwitch(ScreenModes.loading);
    try {
      await Services()
          .getRequest('${CoreUrl.crowdfund}crowdfund_user/crowdfund', true, '')
          .then((data) {
        // Navigator.of(Get.overlayContext!).pop();
        var res = data.body;
        crowdlog.wtf(
            '---GET MY PROJECT LIST---:TOKEN: ${GlobalVariables.gStorage.read("token")}.................returned data ${data.body.toString()}');
        switch (data.statusCode) {
          case 200:
            myFundedProjects.value = data.body['result']['items'];
            if (myFundedProjects.isEmpty) {
              visibilitySwitch(ScreenModes.noProject);
            }
            setState(() {});
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
    } catch (e) {
      Get.snackbar(
        'warning_tr'.translationWord(),
        e.toString(),
        backgroundColor: Colors.white60,
        colorText: Colors.black,
      );
      visibilitySwitch(ScreenModes.loading);
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

  double optionBtnsHeight = 0;
  @override
  Widget build(BuildContext context) {
    return Obx(() => profileTop(
            optionBtnsHeight,
            proBtnInx,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Funded Projects',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myFundedProjects.length,
                        itemBuilder: (c, projectIndex) {
                          int progress;
                          var item = myFundedProjects[projectIndex];
                          int amount = item['amount'];
                          int balance = item['invested_amount'];
                          progress = progressProcent(amount, balance).toInt();
                          return eachproject(item, progress, item['img_base64'],
                              () {
                            Get.to(() => Content(
                                  item: item,
                                  proProgress: progress,
                                  imgUrl: item['img_base64'],
                                ));
                          });
                        }),
                    screenModes(ScreenModes.noProject, noProject,
                        'assets/images/empty_box.jpg'),
                    screenModes(ScreenModes.loading, loading, ''),
                    screenModes(ScreenModes.noInternet, noInternet,
                        'assets/images/noInternet.png')
                  ],
                )
              ],
            ), () {
          setState(() {
            optionBtnsHeight == 0
                ? optionBtnsHeight = 500
                : optionBtnsHeight = 0;
          });
        }));
  }
}



  // Transform.rotate(
  //               angle: 3.14 / (rotate + 1) * 2,
  //               child: Container(
  //                 decoration: const BoxDecoration(
  //                     color: Colors.grey, shape: BoxShape.circle),
  //                 width: 50,
  //                 height: 50,
  //                 child: const Icon(
  //                   FontAwesomeIcons.rotateLeft,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),



   // //#region........helper functions.....

  // double rotate = 0;
  // _scrollListener() async {
  //   setState(() {
  //     rotate = scrollController.offset;
  //   });
  //   if (scrollController.offset >= scrollController.position.maxScrollExtent &&
  //       !scrollController.position.outOfRange) {
  //     //reach bottom
  //   }
  //   if (scrollController.offset <= scrollController.position.minScrollExtent &&
  //       !scrollController.position.outOfRange) {
  //     //reach the top
  //   }
  // }

  

  

  // //#endregion......