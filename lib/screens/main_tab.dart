import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/home/home_screen.dart';
import 'package:gerege_app_v2/screens/home/me/me_screen.dart';
import 'package:gerege_app_v2/screens/home/me/tablet/me_screen_tablet.dart';
import 'package:gerege_app_v2/screens/home/news/information_screen.dart';
import 'package:gerege_app_v2/screens/home/qr_reader.dart';
import 'package:gerege_app_v2/screens/home/wallet/wallet_screen.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/drawer.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import '../widget/drawer_tablet.dart';

class MainTab extends StatefulWidget {
  final int indexTab;

  const MainTab({Key? key, required this.indexTab}) : super(key: key);

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  int _selectedIndex = 3;
  Widget currentPage = const MeScreen();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _onItemTapped(widget.indexTab);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          if (GlobalVariables.useTablet) {
            currentPage = const MeScreenTablet();
          } else {
            currentPage = const MeScreen();
          }
          break;
        case 1:
          currentPage = const InfoScreen();
          break;
        case 4:
          currentPage = const HomeScreen();
          break;
        case 2:
          currentPage = const InfoScreen();
          break;
        case 3:
          currentPage = const WalletScreen();
          break;
      }
    });
  }

  final bool _allow = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(_allow);
      },
      child: Row(
        children: [
          GlobalVariables.useTablet
              ? Obx(
                  () => SizedBox(
                    width: GlobalVariables.isTabletSidebar.value ? 250 : 0,
                    child: const DrawerTabletWidget(),
                  ),
                )
              : Container(),
          Expanded(
            child: Scaffold(
              key: _drawerKey,
              drawerEdgeDragWidth: 0.0,
              drawer: const DrawerWidget(),
              appBar: AppBar(
                backgroundColor: CoreColor().backgroundBlue,
                title: const Text('Gerege template'),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    if (GlobalVariables.useTablet) {
                      GlobalVariables.isTabletSidebar.value =
                          !GlobalVariables.isTabletSidebar.value;
                    } else {
                      setState(() {
                        _drawerKey.currentState?.openDrawer();
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          print('qr call');
                          Get.to(() => const QrCodeScanner());
                        });
                      },
                      icon: const Icon(
                        Icons.qr_code,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  )
                ],
                automaticallyImplyLeading: false,
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                elevation: 0.0,
                backgroundColor: CoreColor().backgroundBlue,
                child: Image.asset(
                  "assets/images/solo_logo.png",
                  width: 40,
                ),
                onPressed: () {
                  _onItemTapped(4);
                },
              ),
              bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                notchAndCornersAnimation: null,
                splashSpeedInMilliseconds: 0,
                shadow: const BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  spreadRadius: 1,
                  color: Colors.grey,
                ),
                itemCount: 4,
                tabBuilder: (int index, bool isActive) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      index == 0
                          ? Icon(
                              Icons.account_circle_outlined,
                              size: 21,
                              color: isActive == true
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            )
                          : index == 1
                              ? Icon(
                                  Icons.newspaper,
                                  size: 26,
                                  color: isActive == true
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                )
                              : Icon(
                                  Icons.wallet,
                                  size: 26,
                                  color: isActive == true
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          index == 0
                              ? 'Би'
                              : index == 1
                                  ? 'Мэдээ'
                                  : index == 2
                                      ? 'Мэдээ'
                                      : 'Хэтэвч',
                          maxLines: 1,
                          style: TextStyle(
                            color: isActive == true
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                backgroundColor: CoreColor().backgroundBlue,
                activeIndex: _selectedIndex,
                notchSmoothness: NotchSmoothness.defaultEdge,
                gapLocation: GapLocation.center,
                leftCornerRadius: 20,
                rightCornerRadius: 20,
                onTap: _onItemTapped,
              ),
              body: Container(
                width: GlobalVariables.gWidth,
                height: GlobalVariables.gHeight,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: currentPage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
