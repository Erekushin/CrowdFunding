import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../global_players.dart';
import '../../helpers/services.dart';

class QrCodeScanner extends StatelessWidget {
  const QrCodeScanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // Get.back();
              // Get.off(() => const MainTab(indexTab: 0));
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: CoreColor().backgroundBlue,
          centerTitle: true,
          title: const Text(
            'QR унших',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: const QRViewScanner());
  }
}

class QRViewScanner extends StatefulWidget {
  const QRViewScanner({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewScannerState();
}

class _QRViewScannerState extends State<QRViewScanner> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    // requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
    } else if (status == PermissionStatus.denied) {
      // await openAppSettings();
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  loginQr(searchText) {
    String url = "${CoreUrl.crowdfund}auth/qrlogin?serial_no=$searchText";
    Services().getRequest(url, true, "").then((data) {
      if (data.body['message'] == "success") {
        Get.back();

        Get.snackbar(
          'success_tr'.translationWord(),
          data.body['message'],
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null && mounted) {
      // controller!.pauseCamera();
      controller!.resumeCamera();
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: _buildQrView(context),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: CoreColor().backgroundBlue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: GlobalVariables.gWidth / 1.2 //scanArea,
          ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // setState(() {
      if (scanData.code != '') {
        controller.pauseCamera();
        // controller.resumeCamera();
        loginQr(scanData.code);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
