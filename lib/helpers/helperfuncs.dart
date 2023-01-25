import 'package:intl/intl.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:sunmi_barcode_scanner/sunmi_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:CrowdFund/controller/sumni_scanner.dart';

String time(date) {
  var dateValue = DateFormat("yyyy-MM-dd HH:mm:ss").parseUTC(date);
  String formattedDate = DateFormat("yyyy/MM/dd").format(dateValue);
  return formattedDate;
}

class Reader {
  var sunmiBarcodeScanner = SunmiBarcodeScanner();

  scannerQrBarCode() async {
    String scanData;
    try {
      scanData = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Буцах',
        true,
        ScanMode.DEFAULT,
      );
      return scanData;
    } on PlatformException {
      return null;
    }
  }

  sunmiScanner() {
    final SunmiController sunmiController = Get.put(SunmiController());
    sunmiBarcodeScanner.onBarcodeScanned().listen((event) {
      sunmiController.codeVal.value = event;
    });
  }
}
