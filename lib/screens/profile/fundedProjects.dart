// ignore: file_names
import 'package:flutter/material.dart';
import 'package:CrowdFund/dialogs/snacks.dart';
import 'package:CrowdFund/helpers/working_string.dart';
import 'package:CrowdFund/screens/profile/profile.dart';
import 'package:get/get.dart';

import '../../global_players.dart';
import '../../helpers/backHelper.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/indicators.dart';
import '../../helpers/working_net.dart';
import '../../widget/combos/eachproject.dart';
import '../../widget/combos/helper_widgets.dart';
import '../funding/singleProject.dart';

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
            '---GET MY PROJECT LIST---:TOKEN: ${GlobalVariables.token}.................returned data ${data.body.toString()}');
        GlobalPlayers.frontHelper.requestErrorSnackbar(data, 1, () {
          myFundedProjects.value = data.body['result']['items'];
          if (myFundedProjects.isEmpty) {
            visibilitySwitch(ScreenModes.noProject);
          }
          setState(() {});
        }, () {
          visibilitySwitch(ScreenModes.noInternet);
          warningSnack(res['message'].toString());
        });
      });
      loading.value = false;
    } catch (e) {
      warningSnack(e.toString());
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
  GlobalKey<ScaffoldState> menuSidebarKeyFunded = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => profileTop(
            menuSidebarKeyFunded,
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
                            Get.to(() => SingleProject(
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
