import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../screens/profile/profile.dart';
import '../screens/profile/security.dart';

class ProfileCont extends GetxController {}
///doorh ni ter shigtee huuchin profile dashiglagdaj bsan bolno

// getMyProjects() async {
  //   visibilitySwitch(ScreenModes.loading);
  //   try {
  //     await Services()
  //         .getRequest('${CoreUrl.crowdfund}crowdfund_user/crowdfund', true, '')
  //         .then((data) {
  //       // Navigator.of(Get.overlayContext!).pop();
  //       var res = data.body;
  //       // crowdlog.wtf(
  //       //     '---GET MY PROJECT LIST---:TOKEN: ${GlobalVariables.gStorage.read("token")}.................returned data ${data.body.toString()}');
  //       switch (data.statusCode) {
  //         case 200:
  //           myFundedProjects.value = data.body['result']['items'];
  //           if (myFundedProjects.isEmpty) {
  //             visibilitySwitch(ScreenModes.noProject);
  //           }
  //           break;
  //         case 444:
  //           visibilitySwitch(ScreenModes.noInternet);
  //           Get.snackbar(
  //             'warning_tr'.translationWord(),
  //             res['message'].toString(),
  //             backgroundColor: Colors.white60,
  //             colorText: Colors.black,
  //           );
  //           break;
  //         default:
  //           Get.snackbar(
  //             'warning_tr'.translationWord(),
  //             res['message'].toString(),
  //             backgroundColor: Colors.white60,
  //             colorText: Colors.black,
  //           );
  //       }
  //     });
  //     loading.value = false;
  //     setState(() {
  //       scrollController.animateTo(55,
  //           duration: const Duration(milliseconds: 500), curve: Curves.ease);
  //     });
  //   } catch (e) {
  //     Get.snackbar(
  //       'warning_tr'.translationWord(),
  //       e.toString(),
  //       backgroundColor: Colors.white60,
  //       colorText: Colors.black,
  //     );
  //     visibilitySwitch(ScreenModes.loading);
  //     setState(() {
  //       scrollController.animateTo(55,
  //           duration: const Duration(milliseconds: 500), curve: Curves.ease);
  //     });
  //   }
  // }

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

  //  SizedBox(
  //                 height: GlobalVariables.gHeight,
  //                 child: Stack(
  //                   children: [
  //                     ListView.builder(
  //                         shrinkWrap: true,
  //                         physics: const NeverScrollableScrollPhysics(),
  //                         itemCount: myFundedProjects.length,
  //                         itemBuilder: (c, projectIndex) {
  //                           int progress;
  //                           var item = myFundedProjects[projectIndex];
  //                           int amount = item['amount'];
  //                           int balance = item['invested_amount'];
  //                           progress = progressProcent(amount, balance).toInt();
  //                           return eachproject(
  //                               item, progress, item['img_base64'], () {
  //                             Get.to(() => Content(
  //                                   item: item,
  //                                   proProgress: progress,
  //                                   imgUrl: item['img_base64'],
  //                                 ));
  //                           });
  //                         }),
  //                     screenModes(ScreenModes.noProject, noProject,
  //                         'assets/images/empty_box.jpg'),
  //                     screenModes(ScreenModes.loading, loading, ''),
  //                     screenModes(ScreenModes.noInternet, noInternet,
  //                         'assets/images/noInternet.png')
  //                   ],
  //                 ),
  //               )

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

  // RxBool noProject = false.obs;
  // RxBool loading = false.obs;
  // RxBool noInternet = false.obs;
  // RxBool error = false.obs;
  // visibilitySwitch(ScreenModes mode) {
  //   switch (mode) {
  //     case ScreenModes.data:
  //       noProject.value = false;
  //       loading.value = false;
  //       noInternet.value = false;
  //       error.value = false;
  //       break;
  //     case ScreenModes.noProject:
  //       noProject.value = true;
  //       loading.value = false;
  //       noInternet.value = false;
  //       error.value = false;
  //       break;
  //     case ScreenModes.loading:
  //       noProject.value = false;
  //       loading.value = true;
  //       noInternet.value = false;
  //       error.value = false;
  //       break;
  //     case ScreenModes.noInternet:
  //       noProject.value = false;
  //       loading.value = false;
  //       noInternet.value = true;
  //       error.value = false;
  //       break;
  //     case ScreenModes.error:
  //       noProject.value = false;
  //       loading.value = false;
  //       noInternet.value = false;
  //       error.value = true;
  //       break;
  //     default:
  //   }
  // }

  // RxList myFundedProjects = [].obs;

  // //#endregion......

