import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/route_manager.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BackAppBar extends StatefulWidget {
  final String titleText;
  const BackAppBar({Key? key, required this.titleText}) : super(key: key);

  @override
  State<BackAppBar> createState() => _BackAppBarState();
}

class _BackAppBarState extends State<BackAppBar> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CoreColor().backgroundBlue,
      shadowColor: Colors.transparent,
      elevation: 0,
      leading: InkWell(
        onTap: () {
          Get.back();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      title: Text(
        widget.titleText.translationWord(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: "MBold",
        ),
      ),
      centerTitle: false,
    );
  }
}
